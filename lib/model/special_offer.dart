class SpecialOffer {
  final String discount;
  final String title;
  final String detail;
  final String icon;

  SpecialOffer({
    required this.discount,
    required this.title,
    required this.detail,
    required this.icon,
  });
}

final homeSpecialOffers = <SpecialOffer>[
  SpecialOffer(
    discount: '25%',
    title: "Today’s Special!",
    detail: 'Get discount for every order, only valid for today',
    icon: 'assets/icons/products/img1.webp',
  ),
  SpecialOffer(
    discount: '35%',
    title: "Tomorrow will be better!",
    detail: 'Please give me a star!',
    icon: 'assets/icons/products/img1.webp',
  ),
  SpecialOffer(
    discount: '100%',
    title: "Not discount today!",
    detail: 'If you have any problem, contact me',
    icon: 'assets/icons/products/img1.webp',
  ),
  SpecialOffer(
    discount: '75%',
    title: "It's for you!",
    detail: 'Wish you have a funny time',
    icon: 'assets/icons/products/img1.webp',
  ),
  SpecialOffer(
    discount: '65%',
    title: "Make yourself at home!",
    detail: 'If you have any confuse, let me now',
    icon: 'assets/icons/products/img1.webp',
  ),
];
