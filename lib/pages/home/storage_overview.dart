import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class StorageOverviewPage extends StatefulWidget {
  const StorageOverviewPage({Key? key}) : super(key: key);
  @override
  State<StorageOverviewPage> createState() => _StorageOverviewPageState();
}

class _StorageOverviewPageState extends State<StorageOverviewPage> {
  // List<PathObject> _files = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    // var userDetails = context.read<UserBloc>().user;
    return Scaffold(
      body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                centerTitle: true,
                forceElevated: innerBoxIsScrolled,
                title: const Text("Storage"),
                floating: true,
              )
            ];
          },
          body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: size.height * .25,
                        child: Stack(
                          children: [
                            DChartPieO(
                              animate: true,
                              configRenderPie: ConfigRenderPie(
                                strokeWidthPx: 0,
                                arcWidth: 25,
                                arcLabelDecorator: ArcLabelDecorator(
                                  showLeaderLines: false,
                                  insideLabelStyle: LabelStyle(color: Colors.transparent),
                                  outsideLabelStyle: LabelStyle(color: Colors.transparent),
                                )
                              ),
                              data: [
                                OrdinalData(
                                  domain: 'not_used',
                                  measure: 400,
                                  color: blue
                                ),
                                OrdinalData(
                                  domain: 'used',
                                  measure: 600,
                                  color: purple
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                  "63.5 %",
                                  style: textTheme.headlineSmall!.copyWith(
                                      fontSize: 28, fontWeight: FontWeight.w400)),
                            )
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Total",
                              style: textTheme.bodyMedium!.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                                "${(400 / 1024).toStringAsFixed(2)} GB",
                                style: textTheme.headlineSmall!
                                    .copyWith(fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Used",
                              style: textTheme.bodyMedium!.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                                "${(600 / 1024).toStringAsFixed(2)} GB",
                                style: textTheme.headlineSmall!
                                    .copyWith(fontWeight: FontWeight.w400)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                    Container(
                        height: size.height * .15,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                            color: purple, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Running out of Space?"),
                            const SizedBox(height: 8),
                            Text(
                              "Upgrade to Premium",
                              style: textTheme.displaySmall!.copyWith(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text("and get unlimited storage",
                                style: textTheme.headlineSmall!.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w300))
                          ],
                        )),
                    const SizedBox(
                      height: 24,
                    ),
                    Flexible(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: false,
                        children: [
                          StatTile(
                            fileTypeName: "Documents",
                            icon: Icons.insert_drive_file,
                            totalFiles: 256,
                            color: pink,
                          ),
                          StatTile(
                            fileTypeName: "Videos",
                            icon: Icons.play_arrow,
                            totalFiles: 13,
                          ),
                          StatTile(
                              fileTypeName: "Images",
                              icon: Icons.image,
                              color: green,
                              totalFiles: 3566,
                          ),
                          StatTile(
                              fileTypeName: "Musics",
                              icon: Icons.music_note,
                              totalFiles: 88,
                          ),
                          StatTile(
                              fileTypeName: "Others",
                              icon: Icons.insert_drive_file,
                              color: blueOcean,
                              totalFiles: 197,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile(
      {Key? key,
        required this.fileTypeName,
        this.color = purple,
        required this.icon,
        required this.totalFiles})
      : super(key: key);

  final String fileTypeName;
  final int totalFiles;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration:
        BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          minVerticalPadding: 0,
          onTap: () {},
          leading: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon),
          ),
          title: Text(
            fileTypeName,
            style: textTheme.titleMedium!
                .copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: white),
          ),
          subtitle: Text("$totalFiles files", style: TextStyle(color: grey)),
          trailing: const Icon(Icons.more_vert),
        ));
  }
}
