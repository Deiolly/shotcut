/*
 * Copyright (c) 2014-2022 Meltytech, LLC
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

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Shotcut.Controls 1.0 as Shotcut
import org.shotcut.qml 1.0 as Shotcut

Rectangle {
    id: filterWindow

    signal filterSelected(int index)

    function open() {
        filterWindow.visible = true;
        searchField.focus = true;
    }

    function close() {
        filterWindow.visible = false;
        searchField.text = '';
        searchField.focus = false;
    }

    visible: false
    onVisibleChanged: {
        if (metadatamodel.filter == Shotcut.MetadataModel.FavoritesFilter)
            favButton.checked = true;
        else if (metadatamodel.filter == Shotcut.MetadataModel.VideoFilter)
            vidButton.checked = true;
        else if (metadatamodel.filter == Shotcut.MetadataModel.AudioFilter)
            audButton.checked = true;
        else if (metadatamodel.filter == Shotcut.MetadataModel.LinkFilter)
            lnkButton.checked = true;
    }
    color: activePalette.window

    SystemPalette {
        id: activePalette
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8

        RowLayout {
            id: searchBar

            property var savedFilter

            Layout.fillWidth: true

            TextField {
                id: searchField

                Layout.fillWidth: true
                focus: true
                placeholderText: qsTr("search")
                selectByMouse: true
                text: metadatamodel.search
                onTextChanged: {
                    if (length !== 1 && text !== metadatamodel.search)
                        metadatamodel.search = text;

                    if (length > 0) {
                        parent.savedFilter = typeGroup.checkedButton;
                        favButton.checked = vidButton.checked = audButton.checked = false;
                    } else {
                        parent.savedFilter.checked = true;
                    }
                }
                Keys.onReturnPressed: {
                    menuListView.itemSelected(menuListView.currentIndex);
                    event.accepted = true;
                }
                Keys.onEnterPressed: Keys.onReturnPressed(event)
                Keys.onEscapePressed: {
                    if (text !== '')
                        text = '';
                    else
                        filterWindow.close();
                }
                Keys.onUpPressed: menuListView.selectPrevious()
                Keys.onDownPressed: menuListView.selectNext()
            }

            ToolButton {
                id: clearButton

                padding: 2
                implicitWidth: 20
                implicitHeight: 20
                icon.name: 'edit-clear'
                icon.source: 'qrc:///icons/oxygen/32x32/actions/edit-clear.png'
                hoverEnabled: true
                onClicked: searchField.text = ''

                Shotcut.HoverTip {
                    text: qsTr('Clear search')
                }

            }

        }

        RowLayout {
            id: toolBar

            Layout.fillWidth: true

            ButtonGroup {
                id: typeGroup
            }

            Shotcut.ToggleButton {
                id: favButton

                checked: true
                implicitWidth: 82
                icon.name: 'bookmarks'
                icon.source: 'qrc:///icons/oxygen/32x32/places/bookmarks.png'
                text: qsTr('Favorite')
                ButtonGroup.group: typeGroup
                onClicked: {
                    if (checked) {
                        metadatamodel.filter = Shotcut.MetadataModel.FavoritesFilter;
                        searchField.text = '';
                        checked = true;
                    }
                }

                Shotcut.HoverTip {
                    text: qsTr('Show favorite filters')
                }

            }

            Shotcut.ToggleButton {
                id: vidButton

                implicitWidth: 82
                icon.name: 'video-television'
                icon.source: 'qrc:///icons/oxygen/32x32/devices/video-television.png'
                text: qsTr('Video')
                ButtonGroup.group: typeGroup
                onClicked: {
                    if (checked) {
                        metadatamodel.filter = Shotcut.MetadataModel.VideoFilter;
                        searchField.text = '';
                        checked = true;
                    }
                }

                Shotcut.HoverTip {
                    text: qsTr('Show video filters')
                }

            }

            Shotcut.ToggleButton {
                id: audButton

                implicitWidth: 82
                icon.name: 'speaker'
                icon.source: 'qrc:///icons/oxygen/32x32/actions/speaker.png'
                text: qsTr('Audio')
                ButtonGroup.group: typeGroup
                onClicked: {
                    if (checked) {
                        metadatamodel.filter = Shotcut.MetadataModel.AudioFilter;
                        searchField.text = '';
                        checked = true;
                    }
                }

                Shotcut.HoverTip {
                    text: qsTr('Show audio filters')
                }

            }

            Shotcut.ToggleButton {
                id: lnkButton

                implicitWidth: 82
                visible: attachedfiltersmodel.supportsLinks
                icon.name: 'chronometer'
                icon.source: 'qrc:///icons/oxygen/32x32/actions/chronometer.png'
                text: qsTr('Time')
                ButtonGroup.group: typeGroup
                onClicked: {
                    if (checked) {
                        metadatamodel.filter = Shotcut.MetadataModel.LinkFilter;
                        searchField.text = '';
                        checked = true;
                    }
                }

                Shotcut.HoverTip {
                    text: qsTr('Show time filters')
                }

            }
            // separator

            Button {
                enabled: false
                implicitWidth: 1
                implicitHeight: 20
            }

            Shotcut.Button {
                id: closeButton

                icon.name: 'window-close'
                icon.source: 'qrc:///icons/oxygen/32x32/actions/window-close.png'
                padding: 2
                implicitWidth: 20
                implicitHeight: 20
                onClicked: filterWindow.close()

                Shotcut.HoverTip {
                    text: qsTr('Close menu')
                }

            }

            Item {
                Layout.fillWidth: true
            }

        }

        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: filterWindow.height - toolBar.height - searchBar.height - iconKeywordsRow.height - parent.spacing * (parent.children.length - 1)
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.horizontal.height: 0
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            ScrollBar.vertical.visible: contentHeight > height
            ScrollBar.vertical.width: 16

            ListView {
                id: menuListView

                function itemSelected(index) {
                    if (index > -1) {
                        filterWindow.close();
                        filterSelected(index);
                    }
                }

                function selectNext() {
                    do {
                        currentIndex = Math.min(currentIndex + 1, count - 1);
                    } while (currentItem !== null && !currentItem.visible && currentIndex < count - 1)
                }

                function selectPrevious() {
                    do {
                        menuListView.currentIndex = Math.max(menuListView.currentIndex - 1, 0);
                    } while (!menuListView.currentItem.visible && menuListView.currentIndex > 0)
                }

                anchors.fill: parent
                model: metadatamodel
                boundsBehavior: Flickable.StopAtBounds
                currentIndex: -1
                focus: true
                onCountChanged: {
                    currentIndex = -1;
                }

                delegate: FilterMenuDelegate {
                }

            }

        }

        RowLayout {
            id: iconKeywordsRow

            Layout.preferredHeight: 60

            AnimatedImage {
                id: icon

                source: menuListView.currentIndex >= 0 ? metadatamodel.get(menuListView.currentIndex).icon : ''
                asynchronous: true
                Layout.preferredWidth: parent.Layout.preferredHeight
                Layout.preferredHeight: parent.Layout.preferredHeight
                fillMode: Image.PreserveAspectFit
                onPlayingChanged: {
                    if (!playing)
                        playing = true;

                }
            }

            Label {
                id: keywordsLabel

                text: menuListView.currentIndex >= 0 ? metadatamodel.get(menuListView.currentIndex).keywords : ''
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                Layout.preferredWidth: filterWindow.width - parent.Layout.preferredHeight - 20
            }

        }

    }

}
