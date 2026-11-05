import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:mobil_arici/app/deep_link.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/session_redirect.dart';
import 'package:mobil_arici/app/sheet_page.dart';
import 'package:mobil_arici/app/shell/app_shell.dart';
import 'package:mobil_arici/app/shell/more_screen.dart';
import 'package:mobil_arici/app/shell/scan_screen.dart';
import 'package:mobil_arici/app/sync/initial_sync_screen.dart';
import 'package:mobil_arici/app/sync/sync_screen.dart';
import 'package:mobil_arici/core/business/migratory_gate.dart';
import 'package:mobil_arici/core/design_system/gallery/component_gallery_screen.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deleted_screen.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_providers.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_screen.dart';
import 'package:mobil_arici/features/account_deletion/presentation/deletion_pending_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiaries_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_detail_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_form_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_location_picker_screen.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_code_screen.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_controller.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_email_screen.dart';
import 'package:mobil_arici/features/documents/presentation/document_detail_screen.dart';
import 'package:mobil_arici/features/documents/presentation/document_form_screen.dart';
import 'package:mobil_arici/features/documents/presentation/documents_screen.dart';
import 'package:mobil_arici/features/documents/presentation/road_check_screen.dart';
import 'package:mobil_arici/features/feedback/presentation/feedback_screen.dart';
import 'package:mobil_arici/features/feeding/presentation/feeding_form_screen.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/presentation/customer_form_screen.dart';
import 'package:mobil_arici/features/finance/presentation/customer_screen.dart';
import 'package:mobil_arici/features/finance/presentation/customers_screen.dart';
import 'package:mobil_arici/features/finance/presentation/finance_screen.dart';
import 'package:mobil_arici/features/finance/presentation/payment_form_screen.dart';
import 'package:mobil_arici/features/finance/presentation/transaction_form_screen.dart';
import 'package:mobil_arici/features/finance/presentation/transaction_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_form_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_hives_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_lot_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_scan_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/lab_result_form_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_form_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/lots_screen.dart';
import 'package:mobil_arici/features/health/presentation/diagnosis_result_screen.dart';
import 'package:mobil_arici/features/health/presentation/diagnosis_screen.dart';
import 'package:mobil_arici/features/health/presentation/drug_form_screen.dart';
import 'package:mobil_arici/features/health/presentation/quarantine_hive_screen.dart';
import 'package:mobil_arici/features/health/presentation/treatment_form_screen.dart';
import 'package:mobil_arici/features/health/presentation/varroa_form_screen.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';
import 'package:mobil_arici/features/hives/presentation/assign_label_screen.dart';
import 'package:mobil_arici/features/hives/presentation/bulk_hive_form_screen.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/hives/presentation/hive_form_screen.dart';
import 'package:mobil_arici/features/hives/presentation/hive_label_providers.dart';
import 'package:mobil_arici/features/hives/presentation/hive_link_screen.dart';
import 'package:mobil_arici/features/hives/presentation/labels/hive_labels_screen.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_sheet.dart';
import 'package:mobil_arici/features/inspections/presentation/tour_screen.dart';
import 'package:mobil_arici/features/inspections/presentation/tour_summary_screen.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/presentation/inventory_form_screen.dart';
import 'package:mobil_arici/features/inventory/presentation/inventory_item_screen.dart';
import 'package:mobil_arici/features/inventory/presentation/inventory_screen.dart';
import 'package:mobil_arici/features/inventory/presentation/shopping_list_screen.dart';
import 'package:mobil_arici/features/knowledge/domain/calculator_rules.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';
import 'package:mobil_arici/features/knowledge/presentation/calculator_screen.dart';
import 'package:mobil_arici/features/knowledge/presentation/calculators_screen.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_article_screen.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_category_screen.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_screen.dart';
import 'package:mobil_arici/features/media/presentation/media_viewer_screen.dart';
import 'package:mobil_arici/features/migration/presentation/migration_form_screen.dart';
import 'package:mobil_arici/features/migration/presentation/migration_screen.dart';
import 'package:mobil_arici/features/migration/presentation/migration_stop_form_screen.dart';
import 'package:mobil_arici/features/migration/presentation/migrations_screen.dart';
import 'package:mobil_arici/features/migration/presentation/move_screen.dart';
import 'package:mobil_arici/features/migration/presentation/transport_scan_screen.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/first_apiary_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/setup_in_progress.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_edit_screen.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_screen.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/queens/presentation/old_queens_screen.dart';
import 'package:mobil_arici/features/queens/presentation/queen_card_screen.dart';
import 'package:mobil_arici/features/queens/presentation/queen_form_screen.dart';
import 'package:mobil_arici/features/queens/presentation/queen_rearing_form_screen.dart';
import 'package:mobil_arici/features/queens/presentation/queen_rearing_screen.dart';
import 'package:mobil_arici/features/queens/presentation/rearing_batch_screen.dart';
import 'package:mobil_arici/features/reports/presentation/reports_screen.dart';
import 'package:mobil_arici/features/reports/presentation/season_screen.dart';
import 'package:mobil_arici/features/settings/presentation/developer_menu_screen.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';
import 'package:mobil_arici/features/subsidies/presentation/aks_hive_count_form_screen.dart';
import 'package:mobil_arici/features/subsidies/presentation/subsidies_screen.dart';
import 'package:mobil_arici/features/tasks/presentation/task_form_screen.dart';
import 'package:mobil_arici/features/tasks/presentation/tasks_screen.dart';
import 'package:mobil_arici/features/team/presentation/team_screen.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';
import 'package:mobil_arici/features/today/presentation/attention_screen.dart';
import 'package:mobil_arici/features/today/presentation/today_screen.dart';
import 'package:mobil_arici/features/weather/presentation/apiary_weather_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

const _apiaryId = 'apiaryId';
const _hiveId = 'hiveId';

/// Besleme ve ilaç formu "arılığın tümü" seçili mi açılıyor.
bool _wholeApiary(GoRouterState state) =>
    state.uri.queryParameters[AppRoutes.scopeParameter] ==
    AppRoutes.scopeApiaryValue;
const _mediaId = 'mediaId';
const _taskId = 'taskId';
const _documentId = 'documentId';
const _knowledgeCategory = 'knowledgeCategory';
const _knowledgeArticleId = 'knowledgeArticleId';
const _diagnosisRuleId = 'diagnosisRuleId';
const _calculator = 'calculator';
const _migrationId = 'migrationId';
const _transportId = 'transportId';
const _stopId = 'stopId';
const _inventoryItemId = 'inventoryItemId';
const _harvestId = 'harvestId';
const _lotId = 'lotId';
const _transactionId = 'transactionId';
const _customerId = 'customerId';
const _rearingBatchId = 'rearingBatchId';
const _attentionKind = 'kind';

/// Yoldaki dikkat grubu; bilinmeyen adda null.
AttentionKind? _attentionKindOf(GoRouterState state) =>
    AttentionKind.values.asNameMap()[state.pathParameters[_attentionKind]];

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final isDev = ref.watch(flavorProvider) == Flavor.dev;

  // Router yeniden kurulmasın (sekme yığınları kaybolur); oturum, işletme,
  // kurulum ya da ilk çekme değişince yalnız yönlendirme yeniden
  // değerlendirilir.
  SessionStage stage() => sessionStageOf(
    signedIn: ref.read(currentUserProvider) != null,
    deletionPending: ref.read(pendingDeletionProvider).value != null,
    hasOrganization: ref.read(currentOrganizationProvider).value != null,
    settingUp: ref.read(setupInProgressProvider),
    fullPullDone: ref.read(fullPullDoneProvider).value ?? false,
  );
  final session = ValueNotifier(stage());
  ref
    ..listen(currentUserProvider, (_, _) => session.value = stage())
    ..listen(pendingDeletionProvider, (_, _) => session.value = stage())
    ..listen(currentOrganizationProvider, (_, _) => session.value = stage())
    ..listen(setupInProgressProvider, (_, _) => session.value = stage())
    ..listen(fullPullDoneProvider, (_, _) => session.value = stage())
    ..onDispose(session.dispose);

  // Sekmelerin ve alt gezinmenin üstünde açılan alt sayfaların navigator'ı.
  // docs/design'daki gibi alt gezinme yalnız sekme köklerinde, arılık
  // detayında ve dikkat listesinde görünür; formlar ve kartlar tam ekran.
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    refreshListenable: session,
    // Önce `mobilarici://x/y` → `/x/y` (uygulama içi konumlara dokunmaz);
    // router yeni konumla yeniden çağırınca oturum kapısı uygulanır.
    redirect: (context, state) =>
        deepLinkLocation(state.uri) ??
        sessionRedirect(stage: session.value, location: state.uri),
    // Eşleşmeyen konum (henüz hedefi olmayan derin linkler dahil) hata
    // sayfası yerine Bugün'e düşer.
    onException: (context, state, router) => router.go(AppRoutes.today),
    routes: [
      // Dal sırası AppTab sırasıyla aynı olmalı.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.today,
                builder: (context, state) => const TodayScreen(),
                routes: [
                  GoRoute(
                    path: 'attention/:$_attentionKind',
                    // Bilinmeyen grup (eski ya da bozuk link) Bugün'e düşer.
                    redirect: (context, state) =>
                        _attentionKindOf(state) == null
                        ? AppRoutes.today
                        : null,
                    builder: (context, state) =>
                        AttentionScreen(kind: _attentionKindOf(state)!),
                  ),
                  GoRoute(
                    path: 'weather/:$_apiaryId',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => ApiaryWeatherScreen(
                      apiaryId: state.pathParameters[_apiaryId]!,
                    ),
                  ),
                  // Prod'da bu rotalar hiç yok; derin linkle de açılamaz.
                  if (isDev)
                    GoRoute(
                      path: 'dev',
                      builder: (context, state) => const DeveloperMenuScreen(),
                      routes: [
                        GoRoute(
                          path: 'components',
                          builder: (context, state) =>
                              const ComponentGalleryScreen(),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.apiaries,
                builder: (context, state) => const ApiariesScreen(),
                routes: [
                  // `:apiaryId`'den önce; "new" kimlik sanılmasın.
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const ApiaryFormScreen(),
                  ),
                  GoRoute(
                    path: ':$_apiaryId',
                    builder: (context, state) => ApiaryDetailScreen(
                      apiaryId: state.pathParameters[_apiaryId]!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => ApiaryFormScreen(
                          apiaryId: state.pathParameters[_apiaryId],
                        ),
                      ),
                      GoRoute(
                        path: 'labels',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => HiveLabelsScreen(
                          apiaryId: state.pathParameters[_apiaryId]!,
                        ),
                      ),
                      GoRoute(
                        path: 'harvest',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => HarvestFormScreen(
                          apiaryId: state.pathParameters[_apiaryId]!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'hives',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => HarvestHivesScreen(
                              apiaryId: state.pathParameters[_apiaryId]!,
                            ),
                          ),
                          // Kamera tam ekran; form altta açık kalır.
                          GoRoute(
                            path: 'scan',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => HarvestScanScreen(
                              apiaryId: state.pathParameters[_apiaryId]!,
                            ),
                          ),
                        ],
                      ),
                      // Hasadın yerine açılır; geri tuşu arılığa döner.
                      GoRoute(
                        path: 'harvest-lot/:$_harvestId',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => HarvestLotScreen(
                          apiaryId: state.pathParameters[_apiaryId]!,
                          harvestId: state.pathParameters[_harvestId]!,
                        ),
                      ),
                      // Tur tam ekran (alt gezinme yok); muayene turun
                      // üstünde alttan açılır, kapatınca tura dönülür.
                      GoRoute(
                        path: 'tour',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => TourScreen(
                          apiaryId: state.pathParameters[_apiaryId]!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'hives/:$_hiveId/inspect',
                            parentNavigatorKey: rootNavigatorKey,
                            // Kovan başına ayrı sayfa: Kaydet sıradaki
                            // kovana geçince yeni sayfa açılır.
                            pageBuilder: (context, state) => SheetPage<void>(
                              key: ValueKey(state.matchedLocation),
                              child: TourInspectionSheet(
                                apiaryId: state.pathParameters[_apiaryId]!,
                                hiveId: state.pathParameters[_hiveId]!,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GoRoute(
                        path: 'tour-summary',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => TourSummaryScreen(
                          apiaryId: state.pathParameters[_apiaryId]!,
                        ),
                      ),
                      // `:hiveId`'den önce; "new" ve "bulk" kimlik sanılmasın.
                      GoRoute(
                        path: 'hives/new',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => HiveFormScreen(
                          apiaryId: state.pathParameters[_apiaryId]!,
                        ),
                      ),
                      GoRoute(
                        path: 'hives/bulk',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => BulkHiveFormScreen(
                          apiaryId: state.pathParameters[_apiaryId]!,
                        ),
                      ),
                      GoRoute(
                        path: 'hives/:$_hiveId',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => HiveCardScreen(
                          apiaryId: state.pathParameters[_apiaryId]!,
                          hiveId: state.pathParameters[_hiveId]!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => HiveFormScreen(
                              apiaryId: state.pathParameters[_apiaryId]!,
                              hiveId: state.pathParameters[_hiveId],
                            ),
                          ),
                          GoRoute(
                            path: 'queen',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => QueenCardScreen(
                              apiaryId: state.pathParameters[_apiaryId]!,
                              hiveId: state.pathParameters[_hiveId]!,
                            ),
                            routes: [
                              GoRoute(
                                path: 'new',
                                parentNavigatorKey: rootNavigatorKey,
                                builder: (context, state) => QueenFormScreen(
                                  hiveId: state.pathParameters[_hiveId]!,
                                ),
                              ),
                              GoRoute(
                                path: 'edit',
                                parentNavigatorKey: rootNavigatorKey,
                                builder: (context, state) => QueenFormScreen(
                                  hiveId: state.pathParameters[_hiveId]!,
                                  editing: true,
                                ),
                              ),
                            ],
                          ),
                          GoRoute(
                            path: 'varroa',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => VarroaFormScreen(
                              hiveId: state.pathParameters[_hiveId]!,
                            ),
                          ),
                          GoRoute(
                            path: 'treat',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => TreatmentFormScreen(
                              apiaryId: state.pathParameters[_apiaryId]!,
                              hiveId: state.pathParameters[_hiveId]!,
                              wholeApiary: _wholeApiary(state),
                            ),
                            routes: [
                              // Eklenen ilaç pop ile uygulamaya döner.
                              GoRoute(
                                path: 'drug',
                                parentNavigatorKey: rootNavigatorKey,
                                builder: (context, state) => DrugFormScreen(
                                  hiveId: state.pathParameters[_hiveId]!,
                                ),
                              ),
                            ],
                          ),
                          GoRoute(
                            path: 'feed',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => FeedingFormScreen(
                              hiveId: state.pathParameters[_hiveId]!,
                              wholeApiary: _wholeApiary(state),
                            ),
                          ),
                          // Kartın üstünde alttan açılır; kart arkada
                          // görünür kalır, kapatınca karta dönülür.
                          GoRoute(
                            path: 'inspect',
                            parentNavigatorKey: rootNavigatorKey,
                            pageBuilder: (context, state) => SheetPage<void>(
                              key: state.pageKey,
                              child: InspectionSheet(
                                hiveId: state.pathParameters[_hiveId]!,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tasks,
                builder: (context, state) => const TasksScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final query = state.uri.queryParameters;
                      // Bozuk gün yok sayılır; form varsayılan günle açılır.
                      final due = DateTime.tryParse(
                        query[AppRoutes.taskDueParameter] ?? '',
                      );
                      return TaskFormScreen(
                        dueDay: due,
                        apiaryId: query[AppRoutes.taskApiaryParameter],
                        title: query[AppRoutes.taskTitleParameter],
                      );
                    },
                  ),
                  GoRoute(
                    path: ':$_taskId/edit',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) =>
                        TaskFormScreen(taskId: state.pathParameters[_taskId]),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.more,
                builder: (context, state) => const MoreScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const SettingsScreen(),
                    routes: [
                      GoRoute(
                        path: 'maps',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => const OfflineMapsScreen(),
                      ),
                      GoRoute(
                        path: 'delete-account',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) =>
                            const AccountDeletionScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'reports',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const ReportsScreen(),
                  ),
                  GoRoute(
                    path: 'old-queens',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const OldQueensScreen(),
                  ),
                  GoRoute(
                    path: 'business',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const BusinessProfileScreen(),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) =>
                            const BusinessProfileEditScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'team',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const TeamScreen(),
                  ),
                  GoRoute(
                    path: 'feedback',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const FeedbackScreen(),
                  ),
                  GoRoute(
                    path: 'documents',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const DocumentsScreen(),
                    routes: [
                      // Sabit yollar `:id`'den önce.
                      GoRoute(
                        path: 'new',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => const DocumentFormScreen(),
                      ),
                      GoRoute(
                        path: 'road-check',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => const RoadCheckScreen(),
                      ),
                      GoRoute(
                        path: ':$_documentId',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => DocumentDetailScreen(
                          documentId: state.pathParameters[_documentId]!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => DocumentFormScreen(
                              documentId: state.pathParameters[_documentId],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'inventory',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const InventoryScreen(),
                    routes: [
                      // Sabit yollar `:id`'den önce.
                      GoRoute(
                        path: 'new',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => InventoryFormScreen(
                          category: InventoryCategory.values
                              .where(
                                (category) =>
                                    category.value ==
                                    state.uri.queryParameters[AppRoutes
                                        .inventoryCategoryParameter],
                              )
                              .firstOrNull,
                        ),
                      ),
                      GoRoute(
                        path: 'shopping',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => const ShoppingListScreen(),
                      ),
                      GoRoute(
                        path: ':$_inventoryItemId',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => InventoryItemScreen(
                          itemId: state.pathParameters[_inventoryItemId]!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => InventoryFormScreen(
                              itemId: state.pathParameters[_inventoryItemId],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'knowledge',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const KnowledgeScreen(),
                    routes: [
                      // Sabit yollar `:id`'den önce.
                      GoRoute(
                        path: 'category/:$_knowledgeCategory',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => KnowledgeCategoryScreen(
                          category: KnowledgeCategory.values
                              .where(
                                (category) =>
                                    category.value ==
                                    state.pathParameters[_knowledgeCategory],
                              )
                              .firstOrNull,
                        ),
                      ),
                      GoRoute(
                        path: 'diagnosis',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => const DiagnosisScreen(),
                        routes: [
                          GoRoute(
                            path: ':$_diagnosisRuleId',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => DiagnosisResultScreen(
                              ruleId: state.pathParameters[_diagnosisRuleId]!,
                            ),
                            routes: [
                              GoRoute(
                                path: 'quarantine',
                                parentNavigatorKey: rootNavigatorKey,
                                builder: (context, state) =>
                                    QuarantineHiveScreen(
                                      ruleId: state
                                          .pathParameters[_diagnosisRuleId]!,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GoRoute(
                        path: 'calculators',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => const CalculatorsScreen(),
                        routes: [
                          GoRoute(
                            path: ':$_calculator',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => CalculatorScreen(
                              calculator: Calculator.fromValue(
                                state.pathParameters[_calculator],
                              ),
                            ),
                          ),
                        ],
                      ),
                      GoRoute(
                        path: ':$_knowledgeArticleId',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => KnowledgeArticleScreen(
                          articleId: state.pathParameters[_knowledgeArticleId]!,
                        ),
                      ),
                    ],
                  ),
                  // Yalnız TR profilinde girişi var (RegionFeatures.subsidies).
                  GoRoute(
                    path: 'subsidies',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const SubsidiesScreen(),
                    routes: [
                      GoRoute(
                        path: 'aks-count',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) =>
                            const AksHiveCountFormScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'season',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const SeasonScreen(),
                  ),
                  GoRoute(
                    path: 'finance',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const FinanceScreen(),
                    routes: [
                      // Sabit yollar `:id`'den önce.
                      GoRoute(
                        path: 'new',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => TransactionFormScreen(
                          kind:
                              TransactionKind.values
                                  .where(
                                    (kind) =>
                                        kind.value ==
                                        state.uri.queryParameters[AppRoutes
                                            .financeKindParameter],
                                  )
                                  .firstOrNull ??
                              TransactionKind.expense,
                          customerId:
                              state.uri.queryParameters[AppRoutes
                                  .financeCustomerParameter],
                        ),
                      ),
                      GoRoute(
                        path: 'customers',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => const CustomersScreen(),
                        routes: [
                          GoRoute(
                            path: 'new',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) =>
                                const CustomerFormScreen(),
                          ),
                          GoRoute(
                            path: ':$_customerId',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => CustomerScreen(
                              customerId: state.pathParameters[_customerId]!,
                            ),
                            routes: [
                              GoRoute(
                                path: 'edit',
                                parentNavigatorKey: rootNavigatorKey,
                                builder: (context, state) => CustomerFormScreen(
                                  customerId: state.pathParameters[_customerId],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GoRoute(
                        path: ':$_transactionId',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => TransactionScreen(
                          transactionId: state.pathParameters[_transactionId]!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'payment',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => PaymentFormScreen(
                              transactionId:
                                  state.pathParameters[_transactionId]!,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'lots',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const LotsScreen(),
                    routes: [
                      GoRoute(
                        path: ':$_lotId',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) =>
                            LotScreen(lotId: state.pathParameters[_lotId]!),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => LotFormScreen(
                              lotId: state.pathParameters[_lotId]!,
                            ),
                          ),
                          GoRoute(
                            path: 'lab',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => LabResultFormScreen(
                              lotId: state.pathParameters[_lotId]!,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'rearing',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const QueenRearingScreen(),
                    routes: [
                      // Sabit yollar `:id`'den önce.
                      GoRoute(
                        path: 'new',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) =>
                            const QueenRearingFormScreen(),
                      ),
                      GoRoute(
                        path: ':$_rearingBatchId',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => RearingBatchScreen(
                          batchId: state.pathParameters[_rearingBatchId]!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => QueenRearingFormScreen(
                              batchId: state.pathParameters[_rearingBatchId],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'migrations',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) =>
                        const MigratoryGate(child: MigrationsScreen()),
                    routes: [
                      // Sabit yollar `:id`'den önce.
                      GoRoute(
                        path: 'new',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) =>
                            const MigratoryGate(child: MigrationFormScreen()),
                      ),
                      GoRoute(
                        path: ':$_migrationId',
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) => MigratoryGate(
                          child: MigrationScreen(
                            migrationId: state.pathParameters[_migrationId]!,
                          ),
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => MigratoryGate(
                              child: MigrationFormScreen(
                                migrationId: state.pathParameters[_migrationId],
                              ),
                            ),
                          ),
                          GoRoute(
                            path: 'move',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => MigratoryGate(
                              child: MoveScreen(
                                migrationId:
                                    state.pathParameters[_migrationId]!,
                              ),
                            ),
                            routes: [
                              GoRoute(
                                path: ':$_transportId/scan',
                                parentNavigatorKey: rootNavigatorKey,
                                builder: (context, state) => MigratoryGate(
                                  child: TransportScanScreen(
                                    transportId:
                                        state.pathParameters[_transportId]!,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GoRoute(
                            path: 'stops/new',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => MigratoryGate(
                              child: MigrationStopFormScreen(
                                migrationId:
                                    state.pathParameters[_migrationId]!,
                              ),
                            ),
                          ),
                          GoRoute(
                            path: 'stops/:$_stopId/edit',
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) => MigratoryGate(
                              child: MigrationStopFormScreen(
                                migrationId:
                                    state.pathParameters[_migrationId]!,
                                stopId: state.pathParameters[_stopId],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Kabuğun dışında: sekmelerin ve alt gezinmenin üstünde açılır.
      GoRoute(
        path: AppRoutes.scan,
        builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
        path: AppRoutes.locationPicker,
        builder: (context, state) {
          final query = state.uri.queryParameters;
          final latitude = double.tryParse(
            query[AppRoutes.locationPickerLatitudeParameter] ?? '',
          );
          final longitude = double.tryParse(
            query[AppRoutes.locationPickerLongitudeParameter] ?? '',
          );
          return ApiaryLocationPickerScreen(
            initial: latitude == null || longitude == null
                ? null
                : LatLng(latitude, longitude),
          );
        },
      ),
      // Kabuğun dışında: geri tuşu ikona dokunulan sekmeye döner.
      GoRoute(
        path: AppRoutes.sync,
        builder: (context, state) => const SyncScreen(),
      ),
      // Kabuğun dışında: geri tuşu küçük resme dokunulan karta döner.
      GoRoute(
        path: '/media/:$_mediaId',
        builder: (context, state) =>
            MediaViewerScreen(mediaId: state.pathParameters[_mediaId]!),
      ),
      // Kovan etiketinin derin linki (`mobilarici://h/<kimlik>`, telefonun
      // kendi kamerasıyla okutulunca). Kovan bu telefondaysa Okut'taki gibi
      // kartına ve muayenesine yönlenir; geri tuşu arılığa döner. Yoksa
      // etiketi atamayı sunar.
      GoRoute(
        path: '/$hiveLabelHost/:$_hiveId',
        redirect: (context, state) async {
          final hive = await ref
              .read(hiveLabelActionsProvider.notifier)
              .find(hiveLabelCode(state.pathParameters[_hiveId]!));
          return hive == null ? null : AppRoutes.scannedHive(hive);
        },
        builder: (context, state) =>
            HiveLinkScreen(hiveId: state.pathParameters[_hiveId]!),
      ),
      // Kabuğun dışında; geri tuşu tanınmayan kod ekranına döner.
      GoRoute(
        path: AppRoutes.labelAssignPath,
        builder: (context, state) => AssignLabelScreen(
          code: state.uri.queryParameters[AppRoutes.labelCodeParameter] ?? '',
        ),
      ),
      // Kabuğun dışında: çıkışta sekme yığınları da kapanır, sonraki
      // kullanıcı öncekinin ekranlarını görmez.
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInEmailScreen(),
        routes: [
          GoRoute(
            path: 'code',
            // Kod gönderilmeden (ör. derin linkle) gelinirse e-postaya dön.
            redirect: (context, state) =>
                ref.read(signInControllerProvider).email == null
                ? AppRoutes.signIn
                : null,
            builder: (context, state) => const SignInCodeScreen(),
          ),
        ],
      ),
      // Kabuğun dışında: işletme kurulana kadar sekmeler yok.
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingApiary,
        builder: (context, state) => const FirstApiaryScreen(),
      ),
      // Kabuğun dışında: kayıtlar inene kadar sekmeler yok.
      GoRoute(
        path: AppRoutes.initialSync,
        builder: (context, state) => const InitialSyncScreen(),
      ),
      // Kabuğun dışında: hesap silmenin bitişi oturum kapandıktan sonra da
      // açık kalır; bekleyen silme kararı verilene kadar sekmeler yok.
      GoRoute(
        path: AppRoutes.accountDeleted,
        builder: (context, state) => const AccountDeletedScreen(),
      ),
      GoRoute(
        path: AppRoutes.deletionPending,
        builder: (context, state) => const DeletionPendingScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
