import QtQuick 2.0
import org.shotcut.qml 1.0

Metadata {
    type: Metadata.Filter
    objectName: 'blur_pad'
    name: qsTr('Blur: Pad')
    keywords: qsTr('pillar echo fill', 'search keywords for the Blur: Pad video filter') + ' blur: pad'
    mlt_service: 'pillar_echo'
    qml: 'ui.qml'
    vui: 'vui.qml'

    keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['rect']
        parameters: [
            Parameter {
                name: qsTr('Position / Size')
                property: 'rect'
                isRectangle: true
            }
        ]
    }

}
