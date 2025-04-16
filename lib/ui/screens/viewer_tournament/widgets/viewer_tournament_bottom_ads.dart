import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_live_scoring/ui/gen/assets.gen.dart';

class ViewerTournamentBottomAds extends StatelessWidget {
  const ViewerTournamentBottomAds({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxHeight: 51, maxWidth: 750),
        margin: const EdgeInsets.only(top: 54, bottom: 160),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Image.asset(Assets.images.bottomBanner1, fit: BoxFit.contain),
            ),
            Expanded(
              child: SvgPicture.asset(Assets.images.bottomBanner2, fit: BoxFit.contain),
            ),
            Expanded(
              child: SvgPicture.asset(Assets.images.bottomBanner3, fit: BoxFit.contain),
            ),
            Expanded(
              child: SvgPicture.asset(Assets.images.bottomBanner4, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
