/*
 * Copyright (c) 2019 Meltytech, LLC
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import org.shotcut.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr("Noise: Keyframes")
    keywords: qsTr('dirt grunge', 'search keywords for the Noise: Keyframes video filter') + ' noise: keyframes'
    objectName: 'noise_keyframes'
    mlt_service: "frei0r.rgbnoise"
    qml: "ui.qml"

    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['0']
        parameters: [
            Parameter {
                name: qsTr('Amount')
                property: '0'
                isCurve: true
                minimum: 0
                maximum: 1
            }
        ]
    }

}
