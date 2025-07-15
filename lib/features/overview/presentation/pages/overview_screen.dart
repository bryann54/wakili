import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';
import 'package:wakili/features/overview/presentation/widgets/document_list.dart';
import 'package:wakili/features/overview/presentation/widgets/document_card_shimmer.dart';
import 'package:wakili/features/overview/presentation/widgets/empty_state.dart';
import 'package:wakili/features/overview/presentation/widgets/error_state.dart';
import 'package:wakili/features/overview/presentation/widgets/filter_chips.dart';
import 'package:wakili/features/overview/presentation/widgets/search_bar.dart';
import '../bloc/overview_bloc.dart';

@RoutePage()
class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  bool _showFilterChips = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialDocuments();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<OverviewBloc>().add(const LoadMoreDocuments());
    }
  }

  void _loadInitialDocuments() {
    context.read<OverviewBloc>().add(
          LoadLegalDocuments(const DocumentQuery()),
        );
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      context.read<OverviewBloc>().add(SearchDocuments(query));
    } else {
      DocumentType? currentFilterType;
      if (context.read<OverviewBloc>().state is OverviewLoaded) {
        currentFilterType =
            (context.read<OverviewBloc>().state as OverviewLoaded)
                .currentQuery
                .filterType;
      }
      context.read<OverviewBloc>().add(
          LoadLegalDocuments(DocumentQuery(filterType: currentFilterType)));
    }
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        _onSearchChanged('');
      }
    });
  }

  void _toggleFilterChips() {
    setState(() {
      _showFilterChips = !_showFilterChips;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal Documents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _toggleSearchBar,
          ),
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            onPressed: _toggleFilterChips,
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SizedBox(
              height: _showSearchBar ? null : 0.0,
              child: _showSearchBar
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: LegalSearchBar(
                        controller: _searchController,
                        onSearchChanged: _onSearchChanged,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SizedBox(
              height: _showFilterChips ? null : 0.0,
              child: _showFilterChips
                  ? const FilterChipsWidget()
                  : const SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: BlocBuilder<OverviewBloc, OverviewState>(
              builder: (context, state) {
                if (state is OverviewLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return const DocumentCardShimmer();
                    },
                  );
                }
                if (state is OverviewError) {
                  return ErrorState(
                    message: state.message,
                    onRetry: _loadInitialDocuments,
                  );
                }
                if (state is OverviewLoaded) {
                  if (state.documents.isEmpty) {
                    return EmptyState(
                      hasSearchQuery: _searchController.text.isNotEmpty,
                      onClearSearch: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    );
                  }
                  return DocumentList(
                    scrollController: _scrollController,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
