import QtQuick 2.0
import org.shotcut.qml 1.0

Metadata {
    type: Metadata.Filter
    objectName: 'audioDance'
    name: qsTr('Audio Dance Visualization')
    keywords: qsTr('music visualizer reactive transform move size position rotate rotation', 'search keywords for the Audio Dance Visualization video filter') + ' audio dance visualization'
    mlt_service: 'dance'
    qml: 'ui_dance.qml'
    allowMultiple: false
}
