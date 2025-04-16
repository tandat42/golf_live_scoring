import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golf_live_scoring/ui/common/data/progress_state.dart';
import 'package:golf_live_scoring/ui/common/widgets/common_screen_wrapper.dart';
import 'package:golf_live_scoring/ui/common/widgets/content_container.dart';
import 'package:golf_live_scoring/ui/gen/assets.gen.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';

class AuthorizationScreenTemplate<C extends Cubit<S>, S extends ProgressState>
    extends StatelessWidget {
  const AuthorizationScreenTemplate({
    super.key,
    required this.title,
    required this.scrollMaxHeight,
    required this.cubit,
    required this.builder,
  });

  final String title;
  final double scrollMaxHeight;
  final C cubit;
  final BlocWidgetBuilder<S> builder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final textStyles = context.textStyles;
    final colors = context.colors;

    final padding = MediaQuery.paddingOf(context);
    final needScroll = MediaQuery.sizeOf(context).height < scrollMaxHeight;

    return CommonScreenWrapper<C, S>(
      cubit: cubit,
      contentBuilder: (context, state) {
        final content = Column(
          children: [
            if (needScroll) const SizedBox(height: 92) else const Spacer(flex: 92),
            SvgPicture.asset(Assets.images.logo, width: 258, height: 32, fit: BoxFit.contain),
            const SizedBox(height: 7.21),
            Container(width: 228, height: 1, color: theme.dividerColor),
            const SizedBox(height: 30.72),
            Text(title, style: textStyles.title1),
            const SizedBox(height: 55),
            builder.call(context, state),
            if (needScroll) const SizedBox(height: 56) else const Spacer(flex: 56),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    //todo
                  },
                  child: Text(l10n.commonTermsOfService, style: textStyles.footer),
                ),
                const SizedBox(width: 17),
                Container(
                  width: 5,
                  height: 5,
                  decoration: ShapeDecoration(shape: CircleBorder(), color: colors.textFooter),
                ),
                const SizedBox(width: 17),
                GestureDetector(
                  onTap: () {
                    //todo
                  },
                  child: Text(l10n.commonPrivacyPolicy, style: textStyles.footer),
                ),
              ],
            ),
          ],
        );

        return needScroll
            ? SingleChildScrollView(
                padding: padding,
                child: ContentContainer(child: content),
              )
            : ContentContainer(child: content);
      },
    );
  }
}
