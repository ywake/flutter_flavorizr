/*
 * Copyright (c) 2023 Angelo Cassano
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:collection/collection.dart';
import 'package:flutter_flavorizr/src/exception/malformed_resource_exception.dart';
import 'package:flutter_flavorizr/src/processors/commons/string_processor.dart';
import 'package:xml/xml.dart';

class AndroidManifestProcessor extends StringProcessor {
  AndroidManifestProcessor({
    super.input,
    required super.config,
  });

  @override
  String execute() {
    XmlDocument document = XmlDocument.parse(input!);

    Iterable<XmlElement> applications = document.findAllElements('application');
    if (applications.isEmpty) {
      throw MalformedResourceException(input!);
    }

    XmlNode application = applications.first;
    XmlAttribute? androidLabel = application.attributes.firstWhereOrNull(
      (XmlAttribute attribute) =>
          attribute.name.toXmlString() == 'android:label',
    );

    if (androidLabel == null) {
      throw MalformedResourceException(input!);
    }

    androidLabel.value = '@string/app_name';

    return document.toXmlString(pretty: true);
  }

  @override
  String toString() => 'AndroidManifestProcessor';
}
