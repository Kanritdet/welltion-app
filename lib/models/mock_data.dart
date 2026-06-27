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
  ];

  // ─────────────────────────────────────────
  // DEVICES
  // ─────────────────────────────────────────
  static final List<DeviceModel> devices = [
    DeviceModel(
      id: 'd1',
      serialNumber: 'WZ2024-001-TH',
      productId: 'p1',
      ownerUserId: 'u1',
      status: DeviceStatus.owned,
      connectedAt: DateTime(2025, 6, 1, 10, 30),
    ),
    DeviceModel(
      id: 'd2',
      serialNumber: 'WZ2024-047-TH',
      productId: 'p1',
      ownerUserId: 'u1',
      status: DeviceStatus.rented,
      venueId: 've1',
      rentalExpiresAt: DateTime(2026, 7, 15),
      connectedAt: DateTime(2026, 6, 20, 14, 0),
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
      amenities: ['ที่จอดรถ', 'WiFi', 'ห้องน้ำ', 'ล็อกเกอร์', 'เครื่องดื่มสมุนไพร'],
      priceInfo: '฿890 / session · ฿4,500 / วัน',
      rentalOptions: [RentalOption.session, RentalOption.daily],
      openingHours: 'จ–ศ 09:00–21:00 · ส–อ 10:00–20:00',
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
      amenities: ['WiFi', 'ที่จอดรถ', 'ร้านชาสมุนไพร', 'ห้องอาบน้ำ'],
      priceInfo: '฿1,200 / session',
      rentalOptions: [RentalOption.session],
      openingHours: 'ทุกวัน 08:00–22:00',
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
      amenities: ['สวนญี่ปุ่น', 'WiFi', 'ที่จอดรถ', 'ล็อกเกอร์', 'เสื้อผ้า Zen'],
      priceInfo: '฿750 / session · ฿3,200 / วัน',
      rentalOptions: [RentalOption.session, RentalOption.daily],
      openingHours: 'จ–ศ 07:00–20:00 · ส–อ 08:00–20:00',
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
