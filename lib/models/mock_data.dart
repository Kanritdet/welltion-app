import 'user_model.dart';
import 'product_model.dart';
import 'product_variant_model.dart';
import 'device_model.dart';
import 'mode_model.dart';
import 'track_model.dart';
import 'healer_model.dart';
import 'playlist_model.dart';
import 'venue_model.dart';
import 'booking_model.dart';
import 'order_item_model.dart';
import 'order_model.dart';
import 'cart_item_model.dart';
import 'biometric_session_model.dart';
import 'machine_model.dart';

/// ข้อมูลจำลองสำหรับ Development — แทนที่ด้วย api_service.dart เมื่อ Back-end พร้อม
abstract class MockData {
  // ─────────────────────────────────────────
  // USERS
  // ─────────────────────────────────────────
  static final List<UserModel> users = [
    UserModel(
      id: 'u1',
      name: 'ทิตสดี จรพร',
      email: 'thitsadee@welltion.app',
      phone: '081-234-5678',
      authMethod: AuthMethod.google,
      language: AppLanguage.th,
      createdAt: DateTime(2025, 1, 15),
    ),
    UserModel(
      id: 'u2',
      name: 'Arisa Tanaka',
      email: 'arisa@welltion.app',
      authMethod: AuthMethod.email,
      language: AppLanguage.en,
      createdAt: DateTime(2025, 3, 10),
    ),
  ];

  static UserModel get currentUser => users[0];

  // ─────────────────────────────────────────
  // MODES
  // ─────────────────────────────────────────
  static const List<ModeModel> modes = [
    ModeModel(
      id: 'm1',
      name: 'Relax',
      description: 'ผ่อนคลายความเครียด ลดความวิตกกังวล',
      color: '#4FC3F7',
    ),
    ModeModel(
      id: 'm2',
      name: 'Focus',
      description: 'เพิ่มสมาธิและประสิทธิภาพการทำงาน',
      color: '#0E3D6E',
    ),
    ModeModel(
      id: 'm3',
      name: 'Sleep',
      description: 'เตรียมร่างกายและจิตใจสู่การนอนหลับลึก',
      color: '#7B61FF',
    ),
    ModeModel(
      id: 'm4',
      name: 'Energize',
      description: 'กระตุ้นพลังงานและความตื่นตัว',
      color: '#F0E4A2',
    ),
  ];

  // ─────────────────────────────────────────
  // PRODUCTS
  // ─────────────────────────────────────────
  static const List<ProductModel> products = [
    ProductModel(
      id: 'p1',
      name: 'WeLLzen Home',
      category: ProductCategory.healthDevice,
      description:
          'เครื่องบำบัดเสียงอัจฉริยะสำหรับบ้าน รองรับคลื่นเสียง 20–20,000 Hz '
          'เชื่อมต่อผ่าน Bluetooth 5.2 วัด HRV และ SpO₂ แบบ Real-time',
      basePrice: 12900,
      thumbnail: 'https://picsum.photos/seed/wellzen-home/400/400',
    ),
    ProductModel(
      id: 'p2',
      name: 'ชุดชามทิเบต Bronze',
      category: ProductCategory.singingBowl,
      description:
          'ชามทิเบตสำริดแท้ 100% ขัดเงาด้วยมือ ให้คลื่นเสียง 432 Hz '
          'ทำในเนปาล โดยช่างฝีมือที่สืบทอดมากกว่า 3 ชั่วอายุคน',
      basePrice: 3500,
      thumbnail: 'https://picsum.photos/seed/singing-bowl/400/400',
    ),
    ProductModel(
      id: 'p3',
      name: 'Crystal Handpan',
      category: ProductCategory.instrument,
      description:
          'แฮนด์แพนคริสตัลเกรดพรีเมียม สเกล D Amara 9 notes '
          'เสียงใส อุณหภูมิคงที่ เหมาะสำหรับ Sound Bath และ Meditation',
      basePrice: 28500,
      thumbnail: 'https://picsum.photos/seed/handpan/400/400',
    ),
    // ── เพิ่มเติม: ขันทิเบต ──────────────────────────────────
    ProductModel(
      id: 'p4',
      name: 'ขันทิเบต ทองเหลือง 7"',
      category: ProductCategory.singingBowl,
      description: 'ขันทิเบตทองเหลืองแท้ขนาด 7 นิ้ว ให้เสียง 432 Hz ผ่อนคลายลึก บรรเทาความเครียดและปรับสมดุลพลังงาน',
      basePrice: 3500,
      thumbnail: 'https://picsum.photos/seed/bowl-7inch/400/400',
      badge: 'ขายดี',
      spec: 'เส้นผ่าศูนย์กลาง 18 ซม.',
    ),
    ProductModel(
      id: 'p5',
      name: 'ขันทิเบต เงิน 9"',
      category: ProductCategory.singingBowl,
      description: 'ขันทิเบตเคลือบเงินขนาด 9 นิ้ว เสียงทุ้มนุ่ม เหมาะสำหรับ Group Sound Bath และการบำบัดเชิงลึก',
      basePrice: 5800,
      thumbnail: 'https://picsum.photos/seed/bowl-9inch/400/400',
      spec: 'เส้นผ่าศูนย์กลาง 23 ซม.',
    ),
    ProductModel(
      id: 'p6',
      name: 'เซ็ต 3 ใบ พร้อมไม้',
      category: ProductCategory.singingBowl,
      description: 'เซ็ตขันทิเบต 3 ใบขนาด 5" 7" 9" พร้อมไม้ตี ครบชุดสำหรับการบำบัดเสียงแบบ Full Chakra Tuning',
      basePrice: 9900,
      thumbnail: 'https://picsum.photos/seed/bowl-set/400/400',
      badge: 'แนะนำ',
      spec: '5" / 7" / 9" + ไม้ตี',
    ),
    // ── เพิ่มเติม: แฮนด์แพน ─────────────────────────────────
    ProductModel(
      id: 'p7',
      name: 'แฮนด์แพน D Minor',
      category: ProductCategory.instrument,
      description: 'แฮนด์แพนสเกล D Minor 9 notes เส้นผ่าศูนย์กลาง 53 ซม. เสียงกังวานทุ้มลึก เหมาะสำหรับ Meditation',
      basePrice: 45000,
      thumbnail: 'https://picsum.photos/seed/handpan-dminor/400/400',
      badge: 'ขายดี',
      spec: '9 notes · 53 ซม.',
    ),
    ProductModel(
      id: 'p8',
      name: 'แฮนด์แพน Kurd Scale',
      category: ProductCategory.instrument,
      description: 'แฮนด์แพน Kurd Scale 9 notes เสียงลึกซึ้งเหมาะสำหรับ Group Healing และ Sound Meditation',
      basePrice: 52000,
      thumbnail: 'https://picsum.photos/seed/handpan-kurd/400/400',
      badge: 'ใหม่',
      spec: '9 notes · 53 ซม.',
    ),
    // ── กระบอกฝน ─────────────────────────────────────────────
    ProductModel(
      id: 'p9',
      name: 'กระบอกฝน ไม้ไผ่ 60 ซม.',
      category: ProductCategory.rainStick,
      description: 'กระบอกฝนทำจากไม้ไผ่ธรรมชาติ ยาว 60 ซม. เสียงฝนอ่อนโยน ผ่อนคลายจิตใจ เหมาะสำหรับ Yoga และ Meditation',
      basePrice: 890,
      thumbnail: 'https://picsum.photos/seed/rainstick-bamboo/400/400',
      spec: 'ยาว 60 ซม. · ไม้ไผ่',
    ),
    ProductModel(
      id: 'p10',
      name: 'กระบอกฝน ไม้สัก 90 ซม.',
      category: ProductCategory.rainStick,
      description: 'กระบอกฝนไม้สักแท้ ยาว 90 ซม. เสียงนุ่มลึก ทนทาน เหมาะสำหรับ Sound Bath และ Chakra Healing',
      basePrice: 1490,
      thumbnail: 'https://picsum.photos/seed/rainstick-teak/400/400',
      badge: 'ขายดี',
      spec: 'ยาว 90 ซม. · ไม้สัก',
    ),
  ];

  // ─────────────────────────────────────────
  // PRODUCT VARIANTS
  // ─────────────────────────────────────────
  static const List<ProductVariantModel> productVariants = [
    ProductVariantModel(
      id: 'pv1a',
      productId: 'p1',
      materialName: 'Aluminium',
      colorName: 'Arctic Silver',
      image: 'https://picsum.photos/seed/wellzen-silver/400/400',
      sku: 'WZ-HOME-SLV',
    ),
    ProductVariantModel(
      id: 'pv1b',
      productId: 'p1',
      materialName: 'Aluminium',
      colorName: 'Space Gray',
      image: 'https://picsum.photos/seed/wellzen-gray/400/400',
      priceAdjust: 500,
      sku: 'WZ-HOME-GRY',
    ),
    ProductVariantModel(
      id: 'pv2a',
      productId: 'p2',
      materialName: 'Bronze',
      colorName: 'ขนาดเล็ก 12 cm',
      image: 'https://picsum.photos/seed/bowl-sm/400/400',
      sku: 'SB-BRZ-SM',
    ),
    ProductVariantModel(
      id: 'pv2b',
      productId: 'p2',
      materialName: 'Bronze',
      colorName: 'ขนาดกลาง 18 cm',
      image: 'https://picsum.photos/seed/bowl-md/400/400',
      priceAdjust: 800,
      sku: 'SB-BRZ-MD',
    ),
    ProductVariantModel(
      id: 'pv3a',
      productId: 'p3',
      materialName: 'Crystal',
      colorName: 'Frosted White',
      image: 'https://picsum.photos/seed/handpan-wht/400/400',
      sku: 'HP-CRY-WHT',
    ),
    ProductVariantModel(id: 'pv4a', productId: 'p4', materialName: 'ทองเหลือง', colorName: '7 นิ้ว', image: 'https://picsum.photos/seed/bowl-7inch/400/400', sku: 'SB-GLD-7'),
    ProductVariantModel(id: 'pv5a', productId: 'p5', materialName: 'เงิน', colorName: '9 นิ้ว', image: 'https://picsum.photos/seed/bowl-9inch/400/400', sku: 'SB-SLV-9'),
    ProductVariantModel(id: 'pv6a', productId: 'p6', materialName: 'ทองเหลือง', colorName: 'เซ็ต 3 ใบ', image: 'https://picsum.photos/seed/bowl-set/400/400', sku: 'SB-SET-3'),
    ProductVariantModel(id: 'pv7a', productId: 'p7', materialName: 'Steel', colorName: 'D Minor', image: 'https://picsum.photos/seed/handpan-dminor/400/400', sku: 'HP-STL-DM'),
    ProductVariantModel(id: 'pv8a', productId: 'p8', materialName: 'Steel', colorName: 'Kurd Scale', image: 'https://picsum.photos/seed/handpan-kurd/400/400', sku: 'HP-STL-KRD'),
    ProductVariantModel(id: 'pv9a', productId: 'p9', materialName: 'ไม้ไผ่', colorName: '60 ซม.', image: 'https://picsum.photos/seed/rainstick-bamboo/400/400', sku: 'RS-BMB-60'),
    ProductVariantModel(id: 'pv10a', productId: 'p10', materialName: 'ไม้สัก', colorName: '90 ซม.', image: 'https://picsum.photos/seed/rainstick-teak/400/400', sku: 'RS-TK-90'),
  ];

  // ─────────────────────────────────────────
  // MACHINES (WeLLzen ที่ค้นหาได้ในหน้า Find)
  // ─────────────────────────────────────────
  static const List<MachineModel> machines = [
    // ve1 — WeLLtion Studio สีลม (3 ตัว)
    MachineModel(id: 'mc1', name: 'WeLLzen #A01', venueName: 'WeLLtion Studio สีลม',
      address: '123 ถ.สีลม แขวงสีลม เขตบางรัก กรุงเทพ', status: MachineStatus.available, distanceKm: 2.5, priceInfo: '฿70 / 30 นาที'),
    MachineModel(id: 'mc2', name: 'WeLLzen #A02', venueName: 'WeLLtion Studio สีลม',
      address: '123 ถ.สีลม แขวงสีลม เขตบางรัก กรุงเทพ', status: MachineStatus.available, distanceKm: 2.5, priceInfo: '฿70 / 30 นาที'),
    MachineModel(id: 'mc3', name: 'WeLLzen #A03', venueName: 'WeLLtion Studio สีลม',
      address: '123 ถ.สีลม แขวงสีลม เขตบางรัก กรุงเทพ', status: MachineStatus.inUse, distanceKm: 2.5, priceInfo: '฿70 / 30 นาที'),
    // ve2 — Serenity Space ทองหล่อ (2 ตัว)
    MachineModel(id: 'mc4', name: 'WeLLzen #B01', venueName: 'Serenity Space ทองหล่อ',
      address: '55/12 ซ.ทองหล่อ 13 แขวงคลองตันเหนือ เขตวัฒนา กรุงเทพ', status: MachineStatus.available, distanceKm: 4.1, priceInfo: '฿90 / 30 นาที'),
    MachineModel(id: 'mc5', name: 'WeLLzen #B02', venueName: 'Serenity Space ทองหล่อ',
      address: '55/12 ซ.ทองหล่อ 13 แขวงคลองตันเหนือ เขตวัฒนา กรุงเทพ', status: MachineStatus.inUse, distanceKm: 4.1, priceInfo: '฿90 / 30 นาที'),
    // ve3 — Zen Garden อโศก (4 ตัว)
    MachineModel(id: 'mc6', name: 'WeLLzen #C01', venueName: 'Zen Garden อโศก',
      address: '8 ถ.อโศกมนตรี แขวงคลองเตยเหนือ เขตวัฒนา กรุงเทพ', status: MachineStatus.available, distanceKm: 3.3, priceInfo: '฿75 / 30 นาที'),
    MachineModel(id: 'mc7', name: 'WeLLzen #C02', venueName: 'Zen Garden อโศก',
      address: '8 ถ.อโศกมนตรี แขวงคลองเตยเหนือ เขตวัฒนา กรุงเทพ', status: MachineStatus.available, distanceKm: 3.3, priceInfo: '฿75 / 30 นาที'),
    MachineModel(id: 'mc8', name: 'WeLLzen #C03', venueName: 'Zen Garden อโศก',
      address: '8 ถ.อโศกมนตรี แขวงคลองเตยเหนือ เขตวัฒนา กรุงเทพ', status: MachineStatus.available, distanceKm: 3.3, priceInfo: '฿75 / 30 นาที'),
    MachineModel(id: 'mc9', name: 'WeLLzen #C04', venueName: 'Zen Garden อโศก',
      address: '8 ถ.อโศกมนตรี แขวงคลองเตยเหนือ เขตวัฒนา กรุงเทพ', status: MachineStatus.available, distanceKm: 3.3, priceInfo: '฿75 / 30 นาที'),
  ];

  // ─────────────────────────────────────────
  // DEVICES
  // ─────────────────────────────────────────
  static final List<DeviceModel> devices = [
    DeviceModel(
      id: 'd1',
      serialNumber: 'WSB01145',
      productId: 'p1',
      ownerUserId: 'u1',
      status: DeviceStatus.owned,
      connectedAt: DateTime(2025, 1, 12, 10, 30),
      customName: 'WeLLzen ห้องนอน',
      modelName: 'WeLLzen Classic',
      firmwareVersion: 'v2.4.1',
      isOnline: true,
      batteryPercent: 78,
      lastUsedAt: DateTime(2026, 6, 28, 9, 0),
    ),
    DeviceModel(
      id: 'd2',
      serialNumber: 'WSB02067',
      productId: 'p1',
      ownerUserId: 'u1',
      status: DeviceStatus.owned,
      connectedAt: DateTime(2025, 9, 15, 14, 0),
      customName: 'WeLLzen ห้องทำงาน',
      modelName: 'WeLLzen Classic',
      firmwareVersion: 'v2.4.1',
      isOnline: false,
      batteryPercent: 12,
      lastUsedAt: DateTime(2026, 6, 20, 15, 30),
    ),
    DeviceModel(
      id: 'd3',
      serialNumber: 'WCB00312',
      productId: 'p1',
      ownerUserId: 'u1',
      status: DeviceStatus.owned,
      connectedAt: DateTime(2025, 12, 10, 11, 0),
      customName: 'WeLLzen ห้องนั่งเล่น',
      modelName: 'WeLLzen Crystal Bowl',
      firmwareVersion: 'v1.8.3',
      isOnline: true,
      batteryPercent: 95,
      lastUsedAt: DateTime(2026, 6, 27, 18, 0),
    ),
    // ── Partner venue machines (Mindful Haven อารีย์) ──────────
    DeviceModel(
      id: 'pm1',
      serialNumber: 'ZFS-001',
      productId: 'p1',
      ownerUserId: 'partner-ve1',
      status: DeviceStatus.owned,
      venueId: 've1',
      connectedAt: DateTime(2025, 3, 1, 9, 0),
      customName: 'WeLLzen Classic #1',
      modelName: 'WeLLzen Classic',
      firmwareVersion: 'v2.4.1',
      isOnline: true,
      batteryPercent: 85,
      lastUsedAt: DateTime(2026, 6, 28, 14, 0),
    ),
    DeviceModel(
      id: 'pm2',
      serialNumber: 'ZFS-002',
      productId: 'p1',
      ownerUserId: 'partner-ve1',
      status: DeviceStatus.owned,
      venueId: 've1',
      connectedAt: DateTime(2025, 3, 1, 9, 0),
      customName: 'WeLLzen Classic #2',
      modelName: 'WeLLzen Classic',
      firmwareVersion: 'v2.4.1',
      isOnline: true,
      batteryPercent: 92,
      lastUsedAt: DateTime(2026, 6, 28, 16, 0),
    ),
    DeviceModel(
      id: 'pm3',
      serialNumber: 'ZFS-003',
      productId: 'p1',
      ownerUserId: 'partner-ve1',
      status: DeviceStatus.owned,
      venueId: 've1',
      connectedAt: DateTime(2025, 3, 1, 9, 0),
      customName: 'WeLLzen Classic #3',
      modelName: 'WeLLzen Classic',
      firmwareVersion: 'v1.9.2',
      isOnline: false,
      batteryPercent: 34,
      lastUsedAt: DateTime(2026, 6, 25, 18, 30),
    ),
  ];

  // ─────────────────────────────────────────
  // HEALERS
  // ─────────────────────────────────────────
  static const List<HealerModel> healers = [
    HealerModel(
      id: 'h1',
      name: 'อ.มณีรัตน์ ศรีสวัสดิ์',
      photo: 'https://picsum.photos/seed/healer-mani/200/200',
      bio:
          'ผู้เชี่ยวชาญด้าน Sound Healing และ Tibetan Bowl Therapy มากกว่า 15 ปี '
          'ศึกษาจากเนปาลและอินเดีย ปัจจุบันเป็นอาจารย์ที่ WeLLtion Academy',
      specialties: ['Tibetan Bowl', 'Gong Bath', 'Chakra Healing'],
      serviceVenueIds: ['ve1', 've2'],
      rating: 4.9,
      yearsExp: 15,
      followerCount: 2400,
      line: '@maneeratna',
      phone: '081-234-5678',
      instagram: 'maneeratna.healer',
      services: [
        HealerService(name: 'Private Sound Bath', price: 1500, durationMin: 60),
        HealerService(name: 'Group Tibetan Bowl', price: 600, durationMin: 90),
        HealerService(name: 'Chakra Healing Session', price: 1800, durationMin: 75),
      ],
    ),
    HealerModel(
      id: 'h2',
      name: 'Dr. Kannika Prasert',
      photo: 'https://picsum.photos/seed/healer-kannika/200/200',
      bio:
          'นักดนตรีบำบัดวิชาชีพ (MT-BC) จาก Berklee College of Music '
          'ผสมผสาน Neuroscience กับ Sound Therapy สำหรับผู้ป่วยโรคเครียด',
      specialties: ['Music Therapy', 'Neurologic Music', 'HRV Optimization'],
      serviceVenueIds: ['ve2', 've3'],
      rating: 4.8,
      yearsExp: 10,
      followerCount: 1800,
      line: '@drkannika',
      phone: '089-876-5432',
      instagram: 'dr.kannika.mt',
      services: [
        HealerService(name: 'Music Therapy Session', price: 2000, durationMin: 60),
        HealerService(name: 'Group Meditation', price: 800, durationMin: 90),
      ],
    ),
    HealerModel(
      id: 'h3',
      name: 'พระอาจารย์ประยงค์',
      photo: 'https://picsum.photos/seed/healer-prayong/200/200',
      bio:
          'พระนักปฏิบัติธรรม เชี่ยวชาญการใช้เสียงในการเจริญสติ '
          'จัดเซสชั่น Sound Meditation ควบคู่กับการฝึกหายใจแบบพุทธ',
      specialties: ['Mindfulness Sound', 'Breathing Technique', 'Meditation'],
      serviceVenueIds: ['ve3'],
      rating: 4.7,
      yearsExp: 20,
      followerCount: 3200,
      line: '@prayong.monk',
      services: [
        HealerService(name: 'Sound Meditation', price: 500, durationMin: 60),
        HealerService(name: 'Group Breathing', price: 300, durationMin: 45),
      ],
    ),
  ];

  // ─────────────────────────────────────────
  // VENUES
  // ─────────────────────────────────────────
  static const List<VenueModel> venues = [
    VenueModel(
      id: 've1',
      name: 'WeLLtion Studio สีลม',
      address: '123 ถ.สีลม แขวงสีลม เขตบางรัก กรุงเทพ 10500',
      lat: 13.7234,
      lng: 100.5280,
      photos: [
        'https://picsum.photos/seed/venue-silom-1/800/500',
        'https://picsum.photos/seed/venue-silom-2/800/500',
        'https://picsum.photos/seed/venue-silom-3/800/500',
      ],
      amenities: ['WeLLzen 3 ตัว', 'ที่จอดรถ', 'WiFi', 'ห้องน้ำ', 'เครื่องดื่มสมุนไพร'],
      priceInfo: '฿70 / 30 นาที',
      rentalOptions: [RentalOption.session, RentalOption.daily],
      openingHours: 'จ–ศ 09:00–21:00 · ส–อ 10:00–20:00',
      rating: 4.9,
      reviewCount: 128,
      distanceKm: 2.5,
      description:
          'WeLLtion Studio คือพื้นที่บำบัดใจกลางย่านสีลม ออกแบบห้องเก็บเสียงให้เงียบสงบ พร้อม WeLLzen 3 ตัว เหมาะกับการนั่งหรือนอนฟังเสียงบำบัด มีเจ้าหน้าที่ดูแลและเสิร์ฟชาสมุนไพรตลอดเซสชัน',
      sessionPricing: {30: 70, 45: 100, 60: 130},
    ),
    VenueModel(
      id: 've2',
      name: 'Serenity Space ทองหล่อ',
      address: '55/12 ซ.ทองหล่อ 13 แขวงคลองตันเหนือ เขตวัฒนา กรุงเทพ 10110',
      lat: 13.7305,
      lng: 100.5849,
      photos: [
        'https://picsum.photos/seed/venue-thong-1/800/500',
        'https://picsum.photos/seed/venue-thong-2/800/500',
      ],
      amenities: ['WeLLzen 2 ตัว', 'WiFi', 'ที่จอดรถ', 'ร้านชาสมุนไพร', 'ห้องอาบน้ำ'],
      priceInfo: '฿90 / 30 นาที',
      rentalOptions: [RentalOption.session],
      openingHours: 'ทุกวัน 08:00–22:00',
      rating: 4.7,
      reviewCount: 84,
      distanceKm: 4.1,
      description:
          'Serenity Space คือสตูดิโอบำบัดเสียงย่านทองหล่อ บรรยากาศอบอุ่นสไตล์มินิมอล เปิดทุกวันตลอดสัปดาห์ เหมาะสำหรับผู้ต้องการพักผ่อนจิตใจหลังเลิกงาน',
      sessionPricing: {30: 90, 45: 130, 60: 160},
    ),
    VenueModel(
      id: 've3',
      name: 'Zen Garden อโศก',
      address: '8 ถ.อโศกมนตรี แขวงคลองเตยเหนือ เขตวัฒนา กรุงเทพ 10110',
      lat: 13.7381,
      lng: 100.5605,
      photos: [
        'https://picsum.photos/seed/venue-asok-1/800/500',
        'https://picsum.photos/seed/venue-asok-2/800/500',
        'https://picsum.photos/seed/venue-asok-3/800/500',
      ],
      amenities: ['WeLLzen 4 ตัว', 'สวนญี่ปุ่น', 'WiFi', 'ที่จอดรถ', 'ล็อกเกอร์'],
      priceInfo: '฿75 / 30 นาที',
      rentalOptions: [RentalOption.session, RentalOption.daily],
      openingHours: 'จ–ศ 07:00–20:00 · ส–อ 08:00–20:00',
      rating: 4.8,
      reviewCount: 210,
      distanceKm: 3.3,
      description:
          'Zen Garden คือสวนบำบัดสไตล์ญี่ปุ่นใจกลางอโศก เงียบสงบ ร่มรื่น พร้อม WeLLzen 4 ตัว ให้บริการแบบ session หรือเช่าทั้งวัน เหมาะสำหรับกลุ่มและคอร์สฝึกสมาธิ',
      sessionPricing: {30: 75, 45: 110, 60: 140},
    ),
  ];

  // ─────────────────────────────────────────
  // TRACKS
  // ─────────────────────────────────────────
  static const List<TrackModel> tracks = [
    TrackModel(
      id: 't1',
      title: 'Morning River — 432 Hz',
      coverImage: 'https://picsum.photos/seed/track-morning/400/400',
      durationSeconds: 1800,
      audioUrl: 'https://mock.welltion.app/audio/morning-river.mp3',
      modeId: 'm1',
      healerId: 'h1',
      frequencyHz: 432,
    ),
    TrackModel(
      id: 't2',
      title: 'Deep Focus Flow',
      coverImage: 'https://picsum.photos/seed/track-focus/400/400',
      durationSeconds: 2700,
      audioUrl: 'https://mock.welltion.app/audio/deep-focus.mp3',
      modeId: 'm2',
      healerId: 'h2',
      frequencyHz: 528,
    ),
    TrackModel(
      id: 't3',
      title: 'Lunar Sleep Journey',
      coverImage: 'https://picsum.photos/seed/track-sleep/400/400',
      durationSeconds: 3600,
      audioUrl: 'https://mock.welltion.app/audio/lunar-sleep.mp3',
      modeId: 'm3',
      frequencyHz: 396,
    ),
    TrackModel(
      id: 't4',
      title: 'Solar Rise Energy',
      coverImage: 'https://picsum.photos/seed/track-energy/400/400',
      durationSeconds: 900,
      audioUrl: 'https://mock.welltion.app/audio/solar-rise.mp3',
      modeId: 'm4',
      healerId: 'h2',
      frequencyHz: 741,
    ),
    TrackModel(
      id: 't5',
      title: 'Tibetan Bowl Meditation',
      coverImage: 'https://picsum.photos/seed/track-tibetan/400/400',
      durationSeconds: 2400,
      audioUrl: 'https://mock.welltion.app/audio/tibetan-bowl.mp3',
      modeId: 'm1',
      healerId: 'h1',
      frequencyHz: 432,
    ),
  ];

  // ─────────────────────────────────────────
  // PLAYLISTS
  // ─────────────────────────────────────────
  static const List<PlaylistModel> playlists = [
    PlaylistModel(
      id: 'pl1',
      title: 'Morning Ritual',
      coverImage: 'https://picsum.photos/seed/playlist-morning/400/400',
      type: PlaylistType.special,
      trackIds: ['t1', 't4'],
    ),
    PlaylistModel(
      id: 'pl2',
      title: 'Deep Sleep Journey',
      coverImage: 'https://picsum.photos/seed/playlist-sleep/400/400',
      type: PlaylistType.special,
      trackIds: ['t3', 't5'],
    ),
    PlaylistModel(
      id: 'pl3',
      title: 'อ.มณีรัตน์ — Best of Bowl',
      coverImage: 'https://picsum.photos/seed/playlist-mani/400/400',
      type: PlaylistType.healer,
      healerId: 'h1',
      trackIds: ['t1', 't5'],
    ),
    PlaylistModel(
      id: 'pl4',
      title: '7 วัน ผ่อนคลายลึก',
      coverImage: 'https://picsum.photos/seed/playlist-relax7/400/400',
      type: PlaylistType.special,
      trackIds: ['t1', 't2', 't3', 't4', 't5'],
    ),
    PlaylistModel(
      id: 'pl5',
      title: 'เสียงธรรมชาติบำบัด',
      coverImage: 'https://picsum.photos/seed/playlist-nature/400/400',
      type: PlaylistType.special,
      trackIds: ['t3', 't1', 't5'],
    ),
    PlaylistModel(
      id: 'pl6',
      title: 'คลื่นสมองอัลฟ่า',
      coverImage: 'https://picsum.photos/seed/playlist-alpha/400/400',
      type: PlaylistType.special,
      trackIds: ['t2', 't4', 't1'],
    ),
    PlaylistModel(
      id: 'pl7',
      title: 'สมดุลพลังกาย',
      coverImage: 'https://picsum.photos/seed/playlist-balance/400/400',
      type: PlaylistType.special,
      trackIds: ['t4', 't2', 't5'],
    ),
    PlaylistModel(
      id: 'pl8',
      title: 'ครูนภา · นอนหลับลึก',
      coverImage: 'https://picsum.photos/seed/playlist-kannika/400/400',
      type: PlaylistType.healer,
      healerId: 'h2',
      trackIds: ['t3', 't5', 't1'],
    ),
    PlaylistModel(
      id: 'pl9',
      title: 'ครูวิภา · ฟื้นฟูจิตใจ',
      coverImage: 'https://picsum.photos/seed/playlist-prayong/400/400',
      type: PlaylistType.healer,
      healerId: 'h3',
      trackIds: ['t2', 't4', 't3'],
    ),
    PlaylistModel(
      id: 'pl10',
      title: 'อ.มณีรัตน์ · Sound Bath Deluxe',
      coverImage: 'https://picsum.photos/seed/playlist-mani2/400/400',
      type: PlaylistType.healer,
      healerId: 'h1',
      trackIds: ['t5', 't3', 't1'],
    ),
    PlaylistModel(
      id: 'pl11',
      title: 'Dr.Kannika · HRV Boost',
      coverImage: 'https://picsum.photos/seed/playlist-kannika2/400/400',
      type: PlaylistType.healer,
      healerId: 'h2',
      trackIds: ['t2', 't4', 't1', 't3'],
    ),
  ];

  // ─────────────────────────────────────────
  // BOOKINGS (ครบทุก status)
  // ─────────────────────────────────────────
  static final List<BookingModel> bookings = [
    BookingModel(
      id: 'b1',
      userId: 'u1',
      venueId: 've1',
      healerId: 'h1',
      date: DateTime(2026, 7, 5),
      startTime: '10:00',
      durationMinutes: 60,
      rentalType: BookingRentalType.session,
      price: 890,
      status: BookingStatus.pending,
    ),
    BookingModel(
      id: 'b2',
      userId: 'u1',
      venueId: 've2',
      healerId: 'h2',
      date: DateTime(2026, 7, 10),
      startTime: '14:00',
      durationMinutes: 90,
      rentalType: BookingRentalType.session,
      price: 1200,
      status: BookingStatus.confirmed,
    ),
    BookingModel(
      id: 'b3',
      userId: 'u1',
      venueId: 've1',
      date: DateTime(2026, 6, 20),
      startTime: '11:00',
      durationMinutes: 60,
      rentalType: BookingRentalType.session,
      price: 890,
      status: BookingStatus.cancelled,
    ),
    BookingModel(
      id: 'b4',
      userId: 'u1',
      venueId: 've3',
      healerId: 'h3',
      date: DateTime(2026, 6, 15),
      startTime: '09:00',
      durationMinutes: 480,
      rentalType: BookingRentalType.daily,
      price: 3200,
      status: BookingStatus.completed,
    ),
  ];

  // ─────────────────────────────────────────
  // ORDERS + ORDER ITEMS
  // ─────────────────────────────────────────
  static final List<OrderItemModel> orderItems = [
    const OrderItemModel(
      id: 'oi1',
      orderId: 'ord1',
      variantId: 'pv1a',
      quantity: 1,
      unitPrice: 12900,
    ),
    const OrderItemModel(
      id: 'oi2',
      orderId: 'ord1',
      variantId: 'pv2a',
      quantity: 2,
      unitPrice: 3500,
    ),
    const OrderItemModel(
      id: 'oi3',
      orderId: 'ord2',
      variantId: 'pv3a',
      quantity: 1,
      unitPrice: 28500,
    ),
  ];

  static final List<OrderModel> orders = [
    OrderModel(
      id: 'ord1',
      userId: 'u1',
      items: [orderItems[0], orderItems[1]],
      subtotal: 19900,
      shippingFee: 100,
      total: 20000,
      status: OrderStatus.paid,
      shippingAddress: '123 ถ.สีลม แขวงสีลม เขตบางรัก กรุงเทพ 10500',
      createdAt: DateTime(2026, 6, 10),
    ),
    OrderModel(
      id: 'ord2',
      userId: 'u1',
      items: [orderItems[2]],
      subtotal: 28500,
      shippingFee: 0,
      total: 28500,
      status: OrderStatus.pending,
      shippingAddress: '123 ถ.สีลม แขวงสีลม เขตบางรัก กรุงเทพ 10500',
      createdAt: DateTime(2026, 6, 24),
    ),
  ];

  // ─────────────────────────────────────────
  // CART ITEMS
  // ─────────────────────────────────────────
  static const List<CartItemModel> cartItems = [
    CartItemModel(id: 'ci1', userId: 'u1', variantId: 'pv2b', quantity: 1),
    CartItemModel(id: 'ci2', userId: 'u1', variantId: 'pv1b', quantity: 1),
  ];

  // ─────────────────────────────────────────
  // BIOMETRIC SESSIONS (before & after)
  // ─────────────────────────────────────────
  static final List<BiometricSessionModel> biometricSessions = [
    // ── สัปดาห์ปัจจุบัน (22–28 มิ.ย. 2026) ──
    BiometricSessionModel(
      id: 'bio1',
      userId: 'u1',
      deviceId: 'd1',
      source: BiometricSource.welltionDevice,
      recordedAt: DateTime(2026, 6, 27, 8, 55),
      phase: BiometricPhase.before,
      metrics: const BiometricMetrics(
        readinessScore: 1.01,
        readinessLevel: ReadinessLevel.low,
        heartRate: 78,
        hrv: 28,
        sleepFuelRating: 'Poor',
        sleepFuelHrvDelta: -8.2,
        sleepFuelBpmDelta: 4.1,
        priorDayStress: 'High',
        priorDayStressHrv: 26,
        sleepBankPercent: 38,
        sleepBankBalance: 'Deficit',
        spo2Avg: 96.8,
        spo2Range: '96–98',
        respirationRateAvg: 17.2,
        respirationRange: '16–19',
      ),
    ),
    BiometricSessionModel(
      id: 'bio2',
      userId: 'u1',
      deviceId: 'd1',
      source: BiometricSource.welltionDevice,
      recordedAt: DateTime(2026, 6, 27, 10, 15),
      phase: BiometricPhase.after,
      metrics: const BiometricMetrics(
        readinessScore: 2.42,
        readinessLevel: ReadinessLevel.high,
        heartRate: 62,
        hrv: 54,
        sleepFuelRating: 'Good',
        sleepFuelHrvDelta: 8.5,
        sleepFuelBpmDelta: -3.2,
        priorDayStress: 'Low',
        priorDayStressHrv: 52,
        sleepBankPercent: 74,
        sleepBankBalance: 'Balanced',
        spo2Avg: 98.6,
        spo2Range: '98–99',
        respirationRateAvg: 13.1,
        respirationRange: '12–14',
      ),
    ),
    BiometricSessionModel(
      id: 'bio3',
      userId: 'u1',
      deviceId: 'd1',
      source: BiometricSource.welltionDevice,
      recordedAt: DateTime(2026, 6, 23, 10, 0),
      phase: BiometricPhase.after,
      metrics: const BiometricMetrics(
        readinessScore: 1.44,
        readinessLevel: ReadinessLevel.medium,
        heartRate: 68,
        hrv: 42,
        sleepFuelRating: 'Fair',
        sleepFuelHrvDelta: 2.1,
        sleepFuelBpmDelta: -1.2,
        priorDayStress: 'Moderate',
        priorDayStressHrv: 40,
        sleepBankPercent: 55,
        sleepBankBalance: 'Slight Deficit',
        spo2Avg: 97.4,
        spo2Range: '97–98',
        respirationRateAvg: 15.2,
        respirationRange: '14–16',
      ),
    ),
    BiometricSessionModel(
      id: 'bio4',
      userId: 'u1',
      deviceId: 'd1',
      source: BiometricSource.welltionDevice,
      recordedAt: DateTime(2026, 6, 25, 9, 30),
      phase: BiometricPhase.after,
      metrics: const BiometricMetrics(
        readinessScore: 1.87,
        readinessLevel: ReadinessLevel.medium,
        heartRate: 65,
        hrv: 47,
        sleepFuelRating: 'Fair',
        sleepFuelHrvDelta: 4.3,
        sleepFuelBpmDelta: -2.0,
        priorDayStress: 'Moderate',
        priorDayStressHrv: 44,
        sleepBankPercent: 62,
        sleepBankBalance: 'Slight Surplus',
        spo2Avg: 98.1,
        spo2Range: '97–99',
        respirationRateAvg: 14.6,
        respirationRange: '13–16',
      ),
    ),
  ];

  // ─────────────────────────────────────────
  // HELPER LOOKUPS
  // ─────────────────────────────────────────
  static VenueModel? venueById(String id) =>
      venues.where((v) => v.id == id).firstOrNull;

  static HealerModel? healerById(String id) =>
      healers.where((h) => h.id == id).firstOrNull;

  static ProductModel? productById(String id) =>
      products.where((p) => p.id == id).firstOrNull;

  static ProductVariantModel? variantById(String id) =>
      productVariants.where((v) => v.id == id).firstOrNull;

  static TrackModel? trackById(String id) =>
      tracks.where((t) => t.id == id).firstOrNull;

  static ModeModel? modeById(String id) =>
      modes.where((m) => m.id == id).firstOrNull;

  static List<ProductVariantModel> variantsByProduct(String productId) =>
      productVariants.where((v) => v.productId == productId).toList();

  static List<BookingModel> bookingsByUser(String userId) =>
      bookings.where((b) => b.userId == userId).toList();

  static List<TrackModel> tracksByPlaylist(PlaylistModel playlist) =>
      playlist.trackIds.map(trackById).whereType<TrackModel>().toList();
}
