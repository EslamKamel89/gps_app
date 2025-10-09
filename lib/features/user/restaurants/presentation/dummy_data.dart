import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/import.dart';

final RestaurantDetailedModel demoModel = RestaurantDetailedModel(
  id: 1,
  website: 'example.com',
  verified: 0,
  vendor: Vendor(
    vendorName: 'GrassFed Pure Search',
    priceRange: null,
    address: '13 Whittingham',
    seatingCapacity: 30,
    operatingHours: OperatingHours(
      mon: ['11:00', '22:00'],
      tue: ['11:00', '22:00'],
      wed: ['11:00', '22:00'],
      thu: ['11:00', '22:00'],
      fri: ['11:00', '22:00'],
      sat: ['11:00', '22:00'],
      sun: ['11:00', '22:00'],
    ),
  ),
  user: User(
    fullName: 'Zakaria Alahmed',
    userName: 'Alahmeds',
    email: 'Saeed.alahmed@tawazin.com',
    mobile: '5712285576',
    images: [
      RestaurantImage(
        id: 9,
        // NOTE: path is relative on purpose (as in your API). See resolveMediaUrl() in the screen below.
        path: 'storage/images/user/704a5f77-a857-40fc-880a-50a8862fe509.jpg',
      ),
    ],
  ),
  branches: [
    Branch(
      id: 1,
      branchName: 'GPS Reston',
      phoneNumber: '1115216789',
      website: 'www.gpsOrganic.com',
      longitude: '-77.37785328',
      latitude: '39.06134487',
      images: [
        RestaurantImage(
          id: 9,
          path: 'storage/images/user/704a5f77-a857-40fc-880a-50a8862fe509.jpg',
        ),
      ],
    ),
  ],
  menus: [
    Menu(
      id: 2,
      restaurantId: 1,
      name: "Meat Lovers",
      description: 'High quality grass-fed meats',
      imageId: 4,
      createdAt: DateTime.parse('2025-10-06T11:43:25.000Z'),
      updatedAt: DateTime.parse('2025-10-06T11:43:25.000Z'),
      images: [
        RestaurantImage(
          id: 9,
          path: 'storage/images/user/704a5f77-a857-40fc-880a-50a8862fe509.jpg',
        ),
      ],
      meals: [
        Meal(name: 'Grass-Fed Beef Burger', description: '200g patty, raw cheddar', price: '12.95'),
        Meal(name: 'Wood-Smoked Short Ribs', description: '24h brine, slow smoked', price: '19.50'),
        Meal(name: 'Harissa Lamb Skewers', description: 'Citrus yogurt, mint', price: '15.75'),
      ],
    ),
    Menu(
      id: 3,
      restaurantId: 1,
      name: "Cheese Lovers",
      description: 'Raw & local cheeses',
      imageId: 5,
      createdAt: DateTime.parse('2025-10-06T11:43:25.000Z'),
      updatedAt: DateTime.parse('2025-10-06T11:43:25.000Z'),
      meals: [
        Meal(name: 'Raw Milk Cheese Board', description: 'Farm selection', price: '14.20'),
        Meal(name: 'Baked Brie & Honey', description: 'Wildflower honey', price: '10.90'),
        Meal(name: 'Halloumi Herb Fries', description: 'Olive oil & thyme', price: '9.60'),
      ],
    ),
    Menu(
      id: 4,
      restaurantId: 1,
      name: "Today's Specials",
      description: 'Seasonal picks',
      imageId: 6,
      createdAt: DateTime.parse('2025-10-06T11:43:25.000Z'),
      updatedAt: DateTime.parse('2025-10-06T11:43:25.000Z'),
      meals: [
        Meal(name: 'Wild Salmon Bowl', description: 'Quinoa, dill dressing', price: '17.40'),
        Meal(
          name: 'Truffle Mushroom Tagliatelle',
          description: 'Porcini & truffle',
          price: '16.30',
        ),
        Meal(name: 'Spicy Kimchi Chicken', description: 'Fermented glaze', price: '13.80'),
      ],
    ),
  ],
  certifications: [
    Certification(
      id: 12,
      title: 'one',
      description: 'one',
      restaurantId: 1,
      createdAt: DateTime.parse('2025-10-09T06:14:46.000Z'),
      updatedAt: DateTime.parse('2025-10-09T06:14:46.000Z'),
      file: [
        RestaurantFile(
          path:
              'files/certificate/1759990451_04367a1c-af34-4682-ad0f-65d02e5f257d2826964187819262219.jpg',
        ),
      ],
    ),
  ],
);
