import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class MyHtmlScreen extends StatelessWidget {
  String url =
      '''<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt">
  <span
    style="
      font-size: 24pt;
      font-family: Lexend, sans-serif;
      color: #000000;
      background-color: transparent;
      font-weight: 700;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >Reconciliation</span
  >
</p>
<p><br /></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt">
  <span
    style="
      font-size: 11pt;
      font-family: Lexend, sans-serif;
      color: #000000;
      background-color: transparent;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >Reconciliation is the process through which React updates the UI (Browser
    DOM).</span
  >
</p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt">
  <span
    style="
      font-size: 11pt;
      font-family: Lexend, sans-serif;
      color: #000000;
      background-color: transparent;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >During Reconciliation, React compares the previous state of UI with the new
    state and determines what changes need to be made.&nbsp;</span
  >
</p>
<p><br /></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt">
  <span
    style="
      font-size: 11pt;
      font-family: Lexend, sans-serif;
      color: #000000;
      background-color: transparent;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >For instance when the application renders (run) for the first time, React
    renders the components to the browser DOM, but keeps a copy of the actual
    DOM as a javascript object also known as Virtual DOM. When changes are made
    in application rather than updating the complete Browser DOM, React again
    generate a Virtual DOM, then it compares the latest generated Virtual DOM
    with previously stored Virtual DOM as these Virtual DOMs are nothing but
    javascript object representing actual DOM, performing comparison of 2
    Virtual DOM is fast and less expensive as compared to updating the entire
    browser DOM.</span
  >
</p>
<p><br /></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt">
  <span
    style="
      font-size: 11pt;
      font-family: Lexend, sans-serif;
      color: #000000;
      background-color: transparent;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >Once React calculates the minimum set of changes needed to update the
    actual DOM by comparing the two virtual DOMs, the actual DOM is
    updated.</span
  >
</p>
<p><br /></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt">
  <span
    style="
      font-size: 11pt;
      font-family: Lexend, sans-serif;
      color: #000000;
      background-color: transparent;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >Earlier rendering websites used to update the actual DOM completely each
    time something changed in the application. This was an expensive operation
    that could slow down the rendering of complex applications, particularly
    when there were frequent updates.</span
  >
</p>
<p><br /></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt">
  <span
    style="
      font-size: 11pt;
      font-family: Lexend, sans-serif;
      color: #000000;
      background-color: transparent;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >Updating the actual DOM requires the browser to recalculate the layout of
    the page, repaint the screen, and update the internal representation of the
    document. This process can be time-consuming, especially when there are a
    large number of elements or when the layout of the page is complex.</span
  >
</p>
<p><br /></p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt">
  <span
    style="
      font-size: 11pt;
      font-family: Lexend, sans-serif;
      color: #000000;
      background-color: transparent;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >Conclusion: Reconciliation is the process of updating Browser DOM by
    comparing Virtual DOMs and only updating&nbsp;</span
  ><span
    style="
      font-size: 11pt;
      font-family: Lexend, sans-serif;
      color: #ff0000;
      background-color: transparent;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >changes&nbsp;</span
  ><span
    style="
      font-size: 11pt;
      font-family: Lexend, sans-serif;
      color: #000000;
      background-color: transparent;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >on Actual DOM and&nbsp;</span
  ><span
    style="
      font-size: 11pt;
      font-family: Lexend, sans-serif;
      color: #ff0000;
      background-color: transparent;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >not the complete Actual DOM.</span
  >
</p>
<p dir="ltr" style="line-height: 1.38; margin-top: 0pt; margin-bottom: 0pt">
  <span
    style="
      font-size: 12pt;
      font-family: Roboto, sans-serif;
      color: #d1d5db;
      background-color: #444654;
      font-weight: 400;
      font-style: normal;
      font-variant: normal;
      text-decoration: none;
      vertical-align: baseline;
      white-space: pre;
      white-space: pre-wrap;
    "
    >&nbsp;</span
  >
</p>
<p><br /></p>
<p><br /></p>
<p><br /></p>
<p><br /></p>
''';

  MyHtmlScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('HTML Screen'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: HtmlWidget(
              url,
            ),
          ),
        ),
      ),
    );
  }
}
