import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../utils/assets.dart';
import '../../utils/theme.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/mini_stat_card.dart';
import 'payment_history_screen.dart';

class PaymentAndWalletScreen extends StatefulWidget {
  static const String routeName = '/payment-and-wallet';
  const PaymentAndWalletScreen({super.key});

  @override
  State<PaymentAndWalletScreen> createState() => _PaymentAndWalletScreenState();
}

class _PaymentAndWalletScreenState extends State<PaymentAndWalletScreen> {
  final List<BankCardData> _bankCards = [];
  final List<PaymentTransaction> _transactions = [
    PaymentTransaction(
      clientName: 'Sarah Johnson',
      service: 'Botox',
      appointmentId: 'APT-0001',
      appointmentType: 'Consultation',
      date: '10/29/2025',
      time: '3:00 PM',
      amount: '\$ 350',
    ),
    PaymentTransaction(
      clientName: 'Olivia Brown',
      service: 'Skin Therapy',
      appointmentId: 'APT-0002',
      appointmentType: 'Follow-up',
      date: '10/31/2025',
      time: '11:15 AM',
      amount: '\$ 220',
    ),
    PaymentTransaction(
      clientName: 'Mia Williams',
      service: 'Laser Removal',
      appointmentId: 'APT-0003',
      appointmentType: 'Procedure',
      date: '11/01/2025',
      time: '1:45 PM',
      amount: '\$ 760',
    ),
  ];

  CardFieldInputDetails? _cardDetails;
  String _cardHolderName = '';

  void _showAddBankDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: CustomColors.white,
              surfaceTintColor: Colors.transparent,
              title: Text('Add Payment Card', style: context.fonts.black18w600),
              content: SizedBox(
                width: context.screenWidth > 600
                    ? 500
                    : context.screenWidth * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your card details securely via Stripe. We do not store your card information.',
                      style: context.fonts.grey14w400,
                    ),
                    context.verticalSpace(24),
                    Text('Card Holder Name', style: context.fonts.black14w600),
                    context.verticalSpace(8),
                    TextFormField(
                      decoration: AppDecorations.input(
                        context,
                        hint: 'e.g. John Doe',
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          _cardHolderName = value;
                        });
                      },
                    ),
                    context.verticalSpace(20),
                    Text('Card Details', style: context.fonts.black14w600),
                    context.verticalSpace(8),
                    CardField(
                      onCardChanged: (details) {
                        setDialogState(() {
                          _cardDetails = details;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: context.appEdgeInsets(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: CustomColors.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: CustomColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: CustomColors.purple,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text('Cancel', style: context.fonts.black14w600),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_cardDetails?.complete ?? false) {
                      try {
                        // Create payment method using Stripe
                        final paymentMethod = await Stripe.instance
                            .createPaymentMethod(
                              params: PaymentMethodParams.card(
                                paymentMethodData: PaymentMethodData(
                                  billingDetails: BillingDetails(
                                    name: _cardHolderName,
                                  ),
                                ),
                              ),
                            );
                        final month = paymentMethod.card.expMonth;
                        final year = paymentMethod.card.expYear;
                        final expiry = month != null && year != null
                            ? '$month/$year'
                            : '';
                        setState(() {
                          _bankCards.add(
                            BankCardData(
                              // cardNumber: paymentMethod.card.last4,
                              cardNumber: paymentMethod.card.last4 ?? '',
                              expiryDate: expiry,
                              cardHolderName: _cardHolderName.isEmpty
                                  ? 'Clinic Member'
                                  : _cardHolderName,
                              cvvCode: '***',
                              bankName: (paymentMethod.card.brand ?? 'Card')
                                  .toUpperCase(),
                            ),
                          );
                        });

                        if (context.mounted) {
                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Card added successfully'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error adding card: $e')),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please complete card details'),
                        ),
                      );
                    }
                  },
                  child: Text('Save Card', style: context.fonts.white14w600),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.verticalSpace(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Payment and Wallet', style: context.fonts.black20w600),
                ElevatedButton.icon(
                  onPressed: _showAddBankDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'Add Payment Method',
                    style: context.fonts.white14w600,
                  ),
                ),
              ],
            ),
            context.verticalSpace(14),
            const Divider(color: CustomColors.border),
            context.verticalSpace(20),
            walletInfo(context),
            context.verticalSpace(20),
            bankAccountsSection(context),
            context.verticalSpace(20),
            Text(
              'Payments are processed securely through Stripe. All transactions are encrypted and compliant with PCI DSS and HIPAA standards.',
              style: context.fonts.grey14w400,
            ),
            context.verticalSpace(20),
            totalEarnings(context),
            context.verticalSpace(20),
            searchAndFilter(context),
            context.verticalSpace(20),
            transactionHeader(context),
            context.verticalSpace(20),
            ListView.separated(
              separatorBuilder: (context, index) => context.verticalSpace(15),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              itemBuilder: (context, index) =>
                  transactionTile(context, _transactions[index]),
            ),
            context.verticalSpace(20),
          ],
        ),
      ),
    );
  }

  Widget walletInfo(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Balance', style: context.fonts.grey14w400),
                context.verticalSpace(8),
                Text('\$ 12,450.00', style: context.fonts.black32w700),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: context.appEdgeInsets(horizontal: 20),
            ),
            icon: SvgPicture.asset(
              SvgAssets.withdraw,
              height: context.h(18),
              width: context.w(18),
              colorFilter: const ColorFilter.mode(
                CustomColors.white,
                BlendMode.srcIn,
              ),
            ),
            label: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  Widget totalEarnings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Earnings Overview', style: context.fonts.black18w600),
        context.verticalSpace(16),
        Row(
          children: [
            const MiniStatCard(
              icon: Icons.payments_outlined,
              color: Color(0xFF7DD3D3),
              value: 45200,
              prefix: '\$ ',
              title: 'Total Earnings',
            ),
            context.horizontalSpace(16),
            const MiniStatCard(
              icon: Icons.account_balance_wallet_outlined,
              color: Color(0xFFE89FD5),
              value: 12450,
              prefix: '\$ ',
              title: 'Available Balance',
            ),
          ],
        ),
      ],
    );
  }

  Widget searchAndFilter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoSearchTextField(
            backgroundColor: CustomColors.softGrey,
            padding: context.appEdgeInsets(horizontal: 12, vertical: 12),
            placeholder: 'Search transactions...',
            style: context.fonts.black14w400,
            placeholderStyle: context.fonts.grey14w400,
          ),
        ),
        context.horizontalSpace(12),
        Container(
          padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: context.appBorderRadius(all: 10),
            color: CustomColors.white,
            border: Border.all(color: CustomColors.border),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                SvgAssets.filter,
                height: context.h(16),
                width: context.w(16),
                colorFilter: const ColorFilter.mode(
                  CustomColors.grey,
                  BlendMode.srcIn,
                ),
              ),
              context.horizontalSpace(8),
              Text("Filter", style: context.fonts.grey14w500),
              context.horizontalSpace(4),
              Icon(
                CupertinoIcons.chevron_down,
                size: context.r(16),
                color: CustomColors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bankAccountsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Methods', style: context.fonts.black18w600),
        context.verticalSpace(16),
        if (_bankCards.isEmpty)
          BorderdContainerWidget(
            width: double.infinity,
            padding: context.appEdgeInsets(horizontal: 20, vertical: 24),
            borderRadius: context.r(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No saved payment methods yet.',
                  style: context.fonts.black16w600,
                ),
                context.verticalSpace(10),
                Text(
                  'Tap Add Payment Method to securely store your card details via Stripe.',
                  style: context.fonts.grey14w400,
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: context.h(220),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _bankCards.length,
              separatorBuilder: (context, index) => context.horizontalSpace(16),
              itemBuilder: (context, index) {
                final card = _bankCards[index];
                return CreditCardWidget(
                  onCreditCardWidgetChange: (_) {},
                  cardNumber: card.cardNumber,
                  obscureInitialCardNumber: true,
                  expiryDate: card.expiryDate,
                  cardHolderName: card.cardHolderName,
                  cvvCode: card.cvvCode,
                  // bankName: card.bankName,
                  showBackView: false,
                  obscureCardNumber: false,
                  obscureCardCvv: false,
                  isHolderNameVisible: true,
                  enableFloatingCard: true,
                  isChipVisible: false,
                  cardBgColor: CustomColors.purple,
                  frontCardBorder: Border.all(
                    color: CustomColors.white.withValues(alpha: 0.2),
                  ),
                  backCardBorder: Border.all(
                    color: CustomColors.white.withValues(alpha: 0.2),
                  ),
                  textStyle: TextStyle(
                    fontSize: context.sp(14),
                    color: CustomColors.white,
                  ),
                  width: context.w(270),
                  height: context.h(190),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget transactionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Transactions', style: context.fonts.black20w600),
        GestureDetector(
          onTap: () {
            context.go(PaymentHistoryScreen.routeName);
          },
          child: Text(
            'View All',
            style: context.fonts.purple14w600.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget transactionTile(BuildContext context, PaymentTransaction transaction) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(horizontal: 18, vertical: 18),
      borderRadius: context.r(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: context.appEdgeInsets(all: 12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.lightPurple,
                ),
                child: Icon(
                  Icons.payment,
                  size: context.r(20),
                  color: CustomColors.purple,
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.clientName,
                      style: context.fonts.black16w600,
                    ),
                    Text(
                      '${transaction.service} • ${transaction.appointmentType}',
                      style: context.fonts.grey14w400,
                    ),
                    Text(
                      'Appointment: ${transaction.appointmentId}',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
              Text(transaction.amount, style: context.fonts.purple16w700),
            ],
          ),
          context.verticalSpace(12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: context.r(14),
                color: CustomColors.grey,
              ),
              context.horizontalSpace(8),
              Text(transaction.date, style: context.fonts.grey14w400),
              context.horizontalSpace(16),
              Icon(
                Icons.access_time,
                size: context.r(14),
                color: CustomColors.grey,
              ),
              context.horizontalSpace(8),
              Text(transaction.time, style: context.fonts.grey14w400),
            ],
          ),
        ],
      ),
    );
  }
}

class BankCardData {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final String bankName;

  BankCardData({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.bankName,
  });
}

class PaymentTransaction {
  final String clientName,
      service,
      appointmentId,
      appointmentType,
      date,
      time,
      amount;

  PaymentTransaction({
    required this.clientName,
    required this.service,
    required this.appointmentId,
    required this.appointmentType,
    required this.date,
    required this.time,
    required this.amount,
  });
}
