class AppConstants {
  static const appName = 'MOSPL';
  static const companyName = 'onlinemadras.com';
  static const apiBaseUrl = String.fromEnvironment(
    'MOSPL_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api',
  );

  static const categories = [
    'Leather Jackets',
    'Leather Bags',
    'Wallets',
    'Belts',
    'Shoes',
    'Watches',
    'Travel Bags',
    'Office Bags',
    'Accessories',
    'Premium Collections',
  ];
}
