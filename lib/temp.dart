// Container(
//           height: columns.length * 25,
//           width: 150,
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   a!,
//                 ),
//               ),
//               if (ShowColumn)
//                 Expanded(
//                   flex: 1,
//                   child: SizedBox(
//                     height: columns.length * 25,
//                     width: 150,
//                     child: ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       itemCount: columns.length,
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemBuilder: (ctx, i) {
//                         return Text(
//                           columns[i],
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               if (ShowFk)
//                 Expanded(
//                   flex: 1,
//                   child: SizedBox(
//                     height: 100,
//                     width: 150,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 5),
//                       child: ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         itemCount: fk.length,
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemBuilder: (ctx, i) {
//                           return Row(
//                             children: [
//                               Container(
//                                 width: 8.0, // The width of the circle
//                                 height: 8.0, // The height of the circle
//                                 decoration: const BoxDecoration(
//                                   color: Colors.blue, // The color of the circle
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               Text(fk[i]),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 )
//             ],
//           ),
//         )