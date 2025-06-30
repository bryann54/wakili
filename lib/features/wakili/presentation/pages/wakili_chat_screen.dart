import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';
import '../widgets/chat_message_widget.dart';

@RoutePage()
class WakiliChatScreen extends StatefulWidget {
  const WakiliChatScreen({super.key});

  @override
  State<WakiliChatScreen> createState() => _WakiliChatScreenState();
}

class _WakiliChatScreenState extends State<WakiliChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _searchQuery = '';
  String? _selectedCategory;

  final List<LegalCategory> _legalCategories = const [
    LegalCategory(
      title: 'Traffic Law',
      icon: Icons.directions_car,
      color: Colors.blue,
      description: 'Traffic violations, licenses, accidents',
    ),
    LegalCategory(
      title: 'Criminal Law',
      icon: Icons.security,
      color: Colors.red,
      description: 'Criminal offenses, procedures, rights',
    ),
    LegalCategory(
      title: 'Family Law',
      icon: Icons.family_restroom,
      color: Colors.purple,
      description: 'Marriage, divorce, custody, inheritance',
    ),
    LegalCategory(
      title: 'Employment',
      icon: Icons.work_outline,
      color: Colors.orange,
      description: 'Labor rights, contracts, disputes',
    ),
    LegalCategory(
      title: 'Property Law',
      icon: Icons.home_work,
      color: Colors.green,
      description: 'Real estate, land, property rights',
    ),
    LegalCategory(
      title: 'Business Law',
      icon: Icons.business_center,
      color: Colors.indigo,
      description: 'Company law, contracts, regulations',
    ),
    LegalCategory(
      title: 'Consumer Rights',
      icon: Icons.shopping_cart,
      color: Colors.teal,
      description: 'Consumer protection, warranties',
    ),
    LegalCategory(
      title: 'Constitutional',
      icon: Icons.account_balance,
      color: Colors.brown,
      description: 'Human rights, civil liberties',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(WakiliBloc chatBloc) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      chatBloc.add(SendStreamMessageEvent(message));
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _onCategorySelected(LegalCategory category) {
    setState(() {
      _selectedCategory = category.title;
    });
    // Add event to modify context for this category
    context.read<WakiliBloc>().add(SetCategoryContextEvent(category.title));
  }

  List<LegalCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _legalCategories;
    return _legalCategories
        .where((category) =>
            category.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            category.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: BlocProvider(
        create: (context) => GetIt.instance<WakiliBloc>(),
        child: Column(
          children: [
            if (_selectedCategory != null)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Focus: $_selectedCategory',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: BlocConsumer<WakiliBloc, WakiliState>(
                listener: (context, state) {
                  if (state is WakiliChatLoaded ||
                      state is WakiliChatErrorState) {
                    _scrollToBottom();
                    if (state is WakiliChatLoaded && state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${state.error}'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  }
                },
                builder: (context, state) {
                  if (state is WakiliChatInitial ||
                      (state is WakiliChatLoaded && state.messages.isEmpty)) {
                    return _buildWelcomeScreen();
                  }

                  List<ChatMessage> messages = [];
                  bool isLoadingTyping = false;

                  if (state is WakiliChatLoaded) {
                    messages = state.messages;
                    isLoadingTyping = state.isLoading;
                  } else if (state is WakiliChatErrorState) {
                    messages = state.messages;
                    isLoadingTyping = false;
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return ChatMessageWidget(message: message);
                          },
                        ),
                      ),
                      if (isLoadingTyping)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Wakili is thinking...',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
     
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  '⚖️',
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    children: const [
                      TextSpan(text: 'Hello! I am '),
                      TextSpan(
                        text: 'Wakili AI',
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your legal assistant for Kenyan law',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search legal topics...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Categories grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCategoriesGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final filteredCategories = _filteredCategories;

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        final isSelected = _selectedCategory == category.title;

        return GestureDetector(
          onTap: () => _onCategorySelected(category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? category.color.withOpacity(0.1)
                  : Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: category.color, width: 2)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return BlocBuilder<WakiliBloc, WakiliState>(
      builder: (context, state) {
        final isLoading = state is WakiliChatLoaded && state.isLoading;
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    hintText: _selectedCategory != null
                        ? 'Ask about $_selectedCategory...'
                        : 'Ask Wakili about Kenyan law...',
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  maxLines: 4,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: isLoading
                      ? null
                      : (_) => _sendMessage(context.read<WakiliBloc>()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isLoading
                        ? Theme.of(context).colorScheme.surfaceVariant
                        : Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                    color: isLoading
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(context).colorScheme.onPrimary,
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_messageController.text.trim().isNotEmpty) {
                              _sendMessage(context.read<WakiliBloc>());
                            }
                          },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


