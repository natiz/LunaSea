import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';
import 'package:lunasea/system/network/network.dart';
import 'package:lunasea/system/quick_actions/quick_actions.dart';
import 'package:lunasea/utils/profile_tools.dart';

class SettingsConfigurationRouter extends SettingsPageRouter {
  SettingsConfigurationRouter() : super('/settings/configuration');

  @override
  Widget widget() => _Widget();

  @override
  void defineRoute(FluroRouter router) {
    super.noParameterRouteDefinition(router);
  }
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
    );
  }

  Widget _appBar() {
    return LunaAppBar(
      title: 'settings.Configuration'.tr(),
      scrollControllers: [scrollController],
      actions: [_enabledProfile()],
    );
  }

  Widget _enabledProfile() {
    return LunaBox.profiles.watch(
      builder: (context, _) {
        if (LunaBox.profiles.size < 2) return const SizedBox();
        return LunaIconButton(
          icon: Icons.switch_account_rounded,
          onPressed: () async {
            final dialogs = SettingsDialogs();
            final enabledProfile = LunaSeaDatabase.ENABLED_PROFILE.read();
            final context = LunaState.navigatorKey.currentContext!;
            final profiles = LunaProfile.list;
            profiles.removeWhere((p) => p == enabledProfile);

            if (profiles.isEmpty) {
              showLunaInfoSnackBar(
                title: 'settings.NoProfilesFound'.tr(),
                message: 'settings.NoAdditionalProfilesAdded'.tr(),
              );
              return;
            }

            final selected = await dialogs.enabledProfile(context, profiles);
            if (selected.item1) {
              LunaProfileTools().changeTo(selected.item2);
            }
          },
        );
      },
    );
  }

  Widget _body() {
    return LunaListView(
      controller: scrollController,
      children: [
        LunaBlock(
          title: 'settings.Appearance'.tr(),
          body: [TextSpan(text: 'settings.AppearanceDescription'.tr())],
          trailing: const LunaIconButton(icon: Icons.brush_rounded),
          onTap: () async =>
              SettingsConfigurationAppearanceRouter().navigateTo(context),
        ),
        LunaBlock(
          title: 'settings.Drawer'.tr(),
          body: [TextSpan(text: 'settings.DrawerDescription'.tr())],
          trailing: const LunaIconButton(icon: Icons.menu_rounded),
          onTap: () async =>
              SettingsConfigurationDrawerRouter().navigateTo(context),
        ),
        LunaBlock(
          title: 'settings.Localization'.tr(),
          body: [TextSpan(text: 'settings.LocalizationDescription'.tr())],
          trailing: const LunaIconButton(icon: Icons.translate_rounded),
          onTap: () async =>
              SettingsConfigurationLocalizationRouter().navigateTo(context),
        ),
        if (LunaNetwork.isSupported)
          LunaBlock(
            title: 'settings.Network'.tr(),
            body: [TextSpan(text: 'settings.NetworkDescription'.tr())],
            trailing: const LunaIconButton(icon: Icons.network_check_rounded),
            onTap: () async =>
                SettingsConfigurationNetworkRouter().navigateTo(context),
          ),
        if (LunaQuickActions.isSupported)
          LunaBlock(
            title: 'settings.QuickActions'.tr(),
            body: [TextSpan(text: 'settings.QuickActionsDescription'.tr())],
            trailing: const LunaIconButton(icon: Icons.rounded_corner_rounded),
            onTap: () async =>
                SettingsConfigurationQuickActionsRouter().navigateTo(context),
          ),
        LunaDivider(),
        ..._moduleList(),
      ],
    );
  }

  List<Widget> _moduleList() {
    return ([LunaModule.DASHBOARD, ...LunaModule.active])
        .map(_tileFromModuleMap)
        .toList();
  }

  Widget _tileFromModuleMap(LunaModule module) {
    return LunaBlock(
      title: module.title,
      body: [
        TextSpan(text: 'settings.ConfigureModule'.tr(args: [module.title]))
      ],
      trailing: LunaIconButton(icon: module.icon),
      onTap: () async => module.settingsRoute!.navigateTo(context),
    );
  }
}
