import 'package:flutter/material.dart';

import 'package:lunasea/modules.dart';
import 'package:lunasea/database/tables/dashboard.dart';
import 'package:lunasea/database/tables/lunasea.dart';
import 'package:lunasea/widgets/ui.dart';
import 'package:lunasea/vendor.dart';
import 'package:lunasea/modules/dashboard/routes/routes.dart';
import 'package:lunasea/modules/dashboard/routes/dashboard/pages/calendar.dart';
import 'package:lunasea/modules/dashboard/routes/dashboard/pages/modules.dart';
import 'package:lunasea/modules/dashboard/routes/dashboard/widgets/switch_view_action.dart';
import 'package:lunasea/modules/dashboard/routes/dashboard/widgets/navigation_bar.dart';

class HomeRouter extends DashboardPageRouter {
  HomeRouter() : super('/dashboard');

  @override
  Home widget() => const Home();

  @override
  void defineRoute(FluroRouter router) =>
      super.noParameterRouteDefinition(router);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _State();
}

class _State extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LunaPageController? _pageController;

  @override
  void initState() {
    super.initState();

    int page = DashboardDatabase.NAVIGATION_INDEX.read();
    _pageController = LunaPageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      module: LunaModule.DASHBOARD,
      body: _body(),
      appBar: _appBar(),
      drawer: LunaDrawer(page: LunaModule.DASHBOARD.key),
      bottomNavigationBar: HomeNavigationBar(pageController: _pageController),
    );
  }

  PreferredSizeWidget _appBar() {
    return LunaAppBar(
      title: 'LunaSea',
      useDrawer: true,
      scrollControllers: HomeNavigationBar.scrollControllers,
      pageController: _pageController,
      actions: [SwitchViewAction(pageController: _pageController)],
    );
  }

  Widget _body() {
    return LunaSeaDatabase.ENABLED_PROFILE.watch(
      builder: (context, _) => LunaPageView(
        controller: _pageController,
        children: [
          ModulesPage(key: ValueKey(LunaSeaDatabase.ENABLED_PROFILE.read())),
          CalendarPage(key: ValueKey(LunaSeaDatabase.ENABLED_PROFILE.read())),
        ],
      ),
    );
  }
}
