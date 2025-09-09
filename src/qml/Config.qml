/*
    SPDX-FileCopyrightText: 2015 Aleix Pol Gonzalez <aleixpol@blue-systems.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kamoso
import org.kde.kirigami as Kirigami
import org.freedesktop.gstreamer.Qt6GLVideoItem

ColumnLayout {

    property int selectedCountdown: 0

    Kirigami.FormLayout {

        Kirigami.Heading {
            text: i18n("Options")
            elide: Text.ElideRight
        }

        QQC2.ComboBox {
            id: countdownCombo
            textRole: "text"
            valueRole: "value"
            model: ListModel {
                id: countdownOptions
            }
            Kirigami.FormData.label: i18n("Countdown")
            onActivated: selectedCountdown = currentValue
            Component.onCompleted: {
                countdownOptions.append({ text: i18n("(none)"), value: 0 })
                countdownOptions.append({ text: i18n("3s"), value: 3 })
                countdownOptions.append({ text: i18n("5s"), value: 5 })
                countdownOptions.append({ text: i18n("10s"), value: 10 })
                currentIndex = 0
                selectedCountdown = currentValue
            }
        }
    }

    GridView {
        id: view
        readonly property int columnCount: 3
        cellWidth: Math.floor(width / view.columnCount)
        cellHeight: cellWidth * 3 / 4
        Layout.fillHeight: true
        Layout.fillWidth: true
        clip: true

        header: QQC2.Control {
            height: effectsGalleryHeading.height + Kirigami.Units.largeSpacing
            Kirigami.Heading {
                id: effectsGalleryHeading
                level: 1
                color: Kirigami.Theme.textColor
                elide: Text.ElideRight
                text: i18n("Effects Gallery")
            }
        }

        model: ListModel {
            ListElement { filters: "identity" }
            ListElement { filters: "bulge" }
            ListElement { filters: "frei0r-filter-cartoon" }
            ListElement { filters: "frei0r-filter-twolay0r" }
            //                 ListElement { filters: "frei0r-filter-color-distance" }
            ListElement { filters: "dicetv" }
            ListElement { filters: "frei0r-filter-distort0r" }
            ListElement { filters: "edgetv" }
            ListElement { filters: "coloreffects preset=heat" }
            ListElement { filters: "videobalance saturation=0 ! agingtv" }
            ListElement { filters: "videobalance saturation=1.5 hue=-0.5" }
            //                 ListElement { filters: "frei0r-filter-invert0r" }
            ListElement { filters: "kaleidoscope" }
            ListElement { filters: "videobalance saturation=1.5 hue=+0.5" }
            ListElement { filters: "mirror" }
            ListElement { filters: "videobalance saturation=0" }
            ListElement { filters: "optv" }
            ListElement { filters: "pinch" }
            ListElement { filters: "quarktv" }
            ListElement { filters: "radioactv" }
            ListElement { filters: "revtv" }
            ListElement { filters: "rippletv" }
            ListElement { filters: "videobalance saturation=2" }
            ListElement { filters: "coloreffects preset=sepia" }
            ListElement { filters: "shagadelictv" }
            //                 ListElement { filters: "frei0r-filter-sobel" }
            ListElement { filters: "square" }
            ListElement { filters: "streaktv" }
            ListElement { filters: "stretch" }
            ListElement { filters: "frei0r-filter-delay0r delaytime=1" }
            ListElement { filters: "twirl" }
            ListElement { filters: "vertigotv" }
            ListElement { filters: "warptv" }
            ListElement { filters: "coloreffects preset=xray" }
        }

        readonly property string sampleImage: view.visible && WebcamControl.currentDevice.length > 0 && view.sampleImage !== Kamoso.sampleImage ? Kamoso.sampleImage : ""

        delegate: Rectangle {
            readonly property int borderWidth: 2
            id: delegateItem

            width: Math.floor(view.width / view.columnCount) - Kirigami.Units.smallSpacing
            height: width * 3 / 4

            color: DeviceManager.playingDevice.filters === model.filters ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor

            MouseArea {
                anchors.centerIn: parent

                width: delegateItem.width - (borderWidth * 2)
                height: delegateItem.height - (borderWidth * 2)

                GstGLQt6VideoItem {
                    anchors.fill: parent
                    acceptEvents: false

                    PipelineItem {
                        playing: false
                        onFailed: {
                            delegateItem.visible = false
                            view.model.remove(index)
                        }

                        description: view.sampleImage.length === 0 ? "" : "filesrc location=\"" + view.sampleImage + "\" ! decodebin ! imagefreeze ! videoconvert ! " + model.filters + " name=last"
                    }
                }

                onClicked: {
                    if (DeviceManager.playingDevice.filters === model.filters)
                        DeviceManager.playingDevice.filters = ""
                    else
                        DeviceManager.playingDevice.filters = model.filters
                }
            }
        }
    }
}