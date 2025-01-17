import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/database/models/indexer.dart';
import 'package:lunasea/modules/search/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsConfigurationSearchRouter extends SettingsPageRouter {
  SettingsConfigurationSearchRouter() : super('/settings/configuration/search');

  @override
  _Widget widget() => _Widget();

  @override
  void defineRoute(FluroRouter router) =>
      super.noParameterRouteDefinition(router);
}

class _Widget extends StatefulWidget {
  @override
  State<_Widget> createState() => _State();
}

class _State extends State<_Widget> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _appBar() {
    return LunaAppBar(
      title: 'Search',
      scrollControllers: [scrollController],
    );
  }

  Widget _bottomNavigationBar() {
    return LunaBottomActionBar(
      actions: [
        LunaButton.text(
          text: 'Add Indexer',
          icon: Icons.add_rounded,
          onTap: () async =>
              SettingsConfigurationSearchAddRouter().navigateTo(context),
        ),
      ],
    );
  }

  Widget _body() {
    return LunaBox.indexers.watch(
      builder: (context, _) => LunaListView(
        controller: scrollController,
        children: [
          LunaModule.SEARCH.informationBanner(),
          ..._indexerSection(),
          ..._customization(),
        ],
      ),
    );
  }

  List<Widget> _indexerSection() {
    if (LunaBox.indexers.isEmpty) {
      return [const LunaMessage(text: 'No Indexers Found')];
    }
    return _indexers;
  }

  List<Widget> get _indexers {
    List<LunaIndexer> indexers = LunaBox.indexers.data.toList();
    indexers.sort((a, b) =>
        a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    List<LunaBlock> list = List.generate(
      indexers.length,
      (index) =>
          _indexerTile(indexers[index], indexers[index].key) as LunaBlock,
    );
    return list;
  }

  Widget _indexerTile(LunaIndexer indexer, int index) {
    return LunaBlock(
      title: indexer.displayName,
      body: [TextSpan(text: indexer.host)],
      trailing: const LunaIconButton.arrow(),
      onTap: () async => SettingsConfigurationSearchEditRouter().navigateTo(
        context,
        index,
      ),
    );
  }

  List<Widget> _customization() {
    return [
      LunaDivider(),
      _hideAdultCategories(),
      _showLinks(),
    ];
  }

  Widget _hideAdultCategories() {
    const _db = SearchDatabase.HIDE_XXX;
    return _db.watch(
      builder: (context, _) => LunaBlock(
        title: 'Hide Adult Categories',
        body: const [TextSpan(text: 'Hide Adult Content')],
        trailing: LunaSwitch(
          value: _db.read(),
          onChanged: _db.update,
        ),
      ),
    );
  }

  Widget _showLinks() {
    const _db = SearchDatabase.SHOW_LINKS;
    return _db.watch(
      builder: (context, _) => LunaBlock(
        title: 'Show Links',
        body: const [TextSpan(text: 'Show Download and Comments Links')],
        trailing: LunaSwitch(
          value: _db.read(),
          onChanged: _db.update,
        ),
      ),
    );
  }
}
