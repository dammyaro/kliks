import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/core/providers/transaction_provider.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List<dynamic> _transactions = [];
  bool _isLoading = true;
  bool _hasError = false;
  final ScrollController _scrollController = ScrollController();
  int _currentOffset = 0;
  static const int _limit = 10;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMoreData) {
        _loadMoreTransactions();
      }
    }
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );
      final transactions = await transactionProvider.getMyTransactions(
        limit: _limit,
        offset: 0,
      );

      setState(() {
        _transactions = transactions;
        _currentOffset = transactions.length;
        _hasMoreData = transactions.length >= _limit;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreTransactions() async {
    if (!_hasMoreData) return;

    setState(() => _isLoading = true);

    try {
      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );
      final newTransactions = await transactionProvider.getMyTransactions(
        limit: _limit,
        offset: _currentOffset,
      );

      setState(() {
        _transactions.addAll(newTransactions);
        _currentOffset += newTransactions.length;
        _hasMoreData = newTransactions.length >= _limit;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min${diff.inMinutes == 1 ? '' : 's'} ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} week${(diff.inDays / 7).floor() == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} month${(diff.inDays / 30).floor() == 1 ? '' : 's'} ago';
    }
    return '${(diff.inDays / 365).floor()} year${(diff.inDays / 365).floor() == 1 ? '' : 's'} ago';
  }

  Widget _buildTransactionItem(dynamic transaction) {
    final type = transaction['type'] as String?;
    final typeFilter = transaction['typeFilter'] as String?;
    final points = transaction['points'] as num?;
    final date =
        transaction['createdAt'] != null
            ? DateTime.parse(transaction['createdAt'] as String)
            : null;

    String displayName;
    if (type == 'CreateEvent') {
      displayName = transaction['event']?['title'] ?? 'Event Created';
    } else {
      displayName = type ?? 'Transaction';
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color:
                  typeFilter?.toLowerCase() == 'spent'
                      ? Color(0xffffd8d8).withOpacity(1)
                      : Color(0xffFEFAE0).withOpacity(1),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Icon(
              typeFilter?.toLowerCase() == 'spent'
                  ? CupertinoIcons.arrow_up_right
                  : CupertinoIcons.arrow_down_left,
              color:
                  typeFilter?.toLowerCase() == 'spent'
                      ? Colors.red
                      : Colors.green,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    fontFamily: 'Metropolis-Medium',
                    letterSpacing: -0.5,
                  ),
                ),
                if (date != null)
                  Row(
                    children: [
                      if (transaction['typeFilter'] != null) ...[
                        Text(
                          transaction['typeFilter'],
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall?.color?.withOpacity(0.5),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Icon(
                            Icons.brightness_1,
                            size: 5,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall?.color?.withOpacity(0.5),
                          ),
                        ),
                      ],
                      Text(
                        _formatTimeAgo(date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10.sp,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Text(
            '${typeFilter?.toLowerCase() == 'spent' ? '-' : '+'}${points ?? 0} PTS',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              fontFamily: 'Metropolis-SemiBold',
              color:
                  typeFilter?.toLowerCase() == 'spent'
                      ? Colors.red
                      : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_isLoading && _transactions.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 40.sp, color: Colors.red),
            SizedBox(height: 8.h),
            Text(
              'Failed to load transactions',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextButton(onPressed: _loadTransactions, child: Text('Retry')),
          ],
        ),
      );
    }

    if (_transactions.isEmpty) {
      return Column(
        children: [
          Opacity(
            opacity: 0.5,
            child: Icon(
              CupertinoIcons.bookmark,
              size: 40.w,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "No Transactions to show",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              height: 1.5,
              letterSpacing: -0.5,
              fontFamily: 'Metropolis-SemiBold',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Opacity(
            opacity: 0.6,
            child: Text(
              "Details on your point earning and\nspending will show here",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: _transactions.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _transactions.length) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildTransactionItem(_transactions[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<AuthProvider>(context).profile;
    final availablePoints = profile?['points'] ?? 0;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Available Points",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              availablePoints.toString(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 50.sp,
                fontFamily: 'Metropolis-Bold',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            Container(
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Image.asset('assets/k-logo.png', width: 30.w, height: 30.h),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      "Attend events with rewards to earn\nmore points",
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Transactions",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey[700]?.withOpacity(0.5) ?? Colors.grey,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/transaction-filter');
                  },
                  child: Opacity(
                    opacity: 0.5,
                    child: Icon(
                      CupertinoIcons.slider_horizontal_3,
                      size: 20.w,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadTransactions,
                child: _buildTransactionsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
