//
//  RedeemTokenView.swift
//  OPass
//
//  Created by 張智堯 on 2022/3/5.
//  2025 OPass.
//

import SwiftUI
import PhotosUI
import CodeScanner

struct RedeemTokenView: View {

    @EnvironmentObject var EventStore: EventStore
    @State private var token: String = ""
    @State private var isCameraSOCPresented = false
    @State private var isManuallySOCPresented = false
    @State private var isHttp403AlertPresented = false
    @State private var isNoQRCodeAlertPresented = false
    @State private var isInvaildTokenAlertPresented = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @FocusState private var focusedField: Field?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Form {
            FastPassLogoView()
                .frame(height: UIScreen.main.bounds.width * 0.3)
                .listRowBackground(Image(.appGradientBackground).resizable().brightness(0.1))

            Section {
                Button { self.isCameraSOCPresented = true } label: {
                    Label {
                        HStack {
                            Text(
                                String(
                                    localized: "redeem_token_view_camera_scan_button",
                                    defaultValue: "Scan QR code with camera",
                                    table: "RedeemTokenView",
                                    comment: ""
                                )
                            )
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.gray.opacity(0.55))
                                .padding(.trailing, 1.5)
                        }
                    } icon: {
                        ZStack {
                            if #available(iOS 26, *) {
                                Image(systemName: "app.fill")
                                    .foregroundStyle(.blue)
                                    .font(.system(size: 28))
                                    .symbolColorRenderingMode(.gradient)
                                Image(systemName: "camera.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 13))
                            } else {
                                Image(systemName: "app.fill")
                                    .foregroundStyle(.blue)
                                    .font(.system(size: 28))
                                Image(systemName: "camera.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 13))
                            }
                        }

                    }
                }

                PhotosPicker(selection: $selectedPhotoItem, matching: .any(of: [.images, .not(.livePhotos)])) {
                    Label {
                        HStack {
                            Text(
                                String(
                                    localized: "redeem_token_view_photos_picker_scan_button",
                                    defaultValue: "Select a picture to scan QR code",
                                    table: "RedeemTokenView",
                                    comment: ""
                                )
                            )
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.gray.opacity(0.55))
                                .padding(.trailing, 1.5)
                        }
                    } icon: {
                        ZStack {
                            if #available(iOS 26, *) {
                                Image(systemName: "app.fill")
                                    .foregroundStyle(.green)
                                    .font(.system(size: 28))
                                    .symbolColorRenderingMode(.gradient)
                                Image(systemName: "photo.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 13))
                            } else {
                                Image(systemName: "app.fill")
                                    .foregroundStyle(.green)
                                    .font(.system(size: 28))
                                Image(systemName: "photo.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 13))
                            }
                        }
                    }
                }
                .alert(
                    String(
                        localized: "redeem_token_view_photos_picker_scan_alert_no_qr_code_found",
                        defaultValue: "No QR code found in picture",
                        table: "RedeemTokenView",
                        comment: ""
                    ),
                    isPresented: $isNoQRCodeAlertPresented
                )

                Button { self.isManuallySOCPresented = true } label: {
                    Label {
                        HStack {
                            Text(
                                String(
                                    localized: "redeem_token_view_enter_token_manually_button",
                                    defaultValue: "Enter token manually",
                                    table: "RedeemTokenView",
                                    comment: ""
                                )
                            )
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.gray.opacity(0.55))
                                .padding(.trailing, 1.5)
                        }
                    } icon: {
                        ZStack {
                            if #available(iOS 26, *) {
                                Image(systemName: "app.fill")
                                    .foregroundStyle(.orange)
                                    .font(.system(size: 28))
                                    .symbolColorRenderingMode(.gradient)
                                Image(systemName: "keyboard.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 13))
                            } else {
                                Image(systemName: "app.fill")
                                    .foregroundStyle(.orange)
                                    .font(.system(size: 28))
                                Image(systemName: "keyboard.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 13))
                            }
                        }
                    }
                }
            }
        }
        .contentMargins(.top, 10)
        .http403Alert(
            title: String(
                localized: "redeem_token_view_alert_http_403_title",
                defaultValue: "Couldn't verify your identity",
                table: "RedeemTokenView",
                comment: ""
            ),
            isPresented: $isHttp403AlertPresented
        )
        .alert(
            String(
                localized: "redeem_token_view_alert_invalid_token_title",
                defaultValue: "Couldn't verify your identity",
                table: "RedeemTokenView",
                comment: ""
            ),
            message: String(
                localized: "redeem_token_view_alert_invalid_token_message",
                defaultValue: "Invaild token",
                table: "RedeemTokenView",
                comment: ""
            ),
            isPresented: $isInvaildTokenAlertPresented
        )
        .slideOverCard(isPresented: $isCameraSOCPresented, backgroundColor: (colorScheme == .dark ? .init(red: 28/255, green: 28/255, blue: 30/255) : .white)) {
            VStack {
                Text(
                    String(
                        localized: "redeem_token_view_camera_scan_title",
                        defaultValue: "Fast Pass",
                        table: "RedeemTokenView",
                        comment: ""
                    )
                )
                .font(Font.largeTitle.weight(.bold))
                Text(
                    String(
                        localized: "redeem_token_view_camera_scan_label",
                        defaultValue: "Scan QR code with camera",
                        table: "RedeemTokenView",
                        comment: ""
                    )
                )

                CodeScannerView(codeTypes: [.qr], scanMode: .once, showViewfinder: false, shouldVibrateOnSuccess: true, completion: handleScan)
                    .frame(height: UIScreen.main.bounds.height * 0.25)
                    .cornerRadius(20)
                    .overlay {
                        if !(AVCaptureDevice.authorizationStatus(for: .video) == .authorized) {
                            VStack {
                                Spacer()
                                Spacer()
                                Text(
                                    String(
                                        localized: "redeem_token_view_camera_scan_action_request_camera_access_description",
                                        defaultValue: "Please allow OPass to access your camera under OPass in your device's settings.",
                                        table: "RedeemTokenView",
                                        comment: ""
                                    )
                                )
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                Spacer()
                                Button {
                                    Constants.openInOS(forURL: URL(string: UIApplication.openSettingsURLString)!)
                                } label: {
                                    Text(
                                        String(
                                            localized: "redeem_token_view_camera_scan_action_request_camera_access_action_settings",
                                            defaultValue: "Open Settings",
                                            table: "RedeemTokenView",
                                            comment: ""
                                        )
                                    )
                                        .foregroundColor(.blue)
                                        .bold()
                                }
                                Spacer()
                                Spacer()
                            }
                            .padding(10)
                        }		
                    }

                VStack(alignment: .leading) {
                    Text(
                        String(
                            localized: "redeem_token_view_camera_scan_action_scan_label",
                            defaultValue: "Scan to get token",
                            table: "RedeemTokenView",
                            comment: ""
                        )
                    ).bold()
                    Text(
                        String(
                            localized: "redeem_token_view_camera_scan_action_scan_description",
                            defaultValue: "Please look for the QR code provided by the email and place it in the viewfinder",
                            table: "RedeemTokenView",
                            comment: ""
                        )
                    )
                        .foregroundColor(Color.gray)
                }
            }
        }
        .slideOverCard(
            isPresented: $isManuallySOCPresented,
            onDismiss: { UIApplication.endEditing() },
            backgroundColor: (colorScheme == .dark ? .init(red: 28/255, green: 28/255, blue: 30/255) : .white)
        ) {
            VStack {
                Text(
                    String(
                        localized: "redeem_token_view_enter_token_manually_title",
                        defaultValue: "Fast Pass",
                        table: "RedeemTokenView",
                        comment: ""
                    )
                )
                .font(Font.largeTitle.weight(.bold))
                Text(
                    String(
                        localized: "redeem_token_view_enter_token_manually_label",
                        defaultValue: "Enter token manually",
                        table: "RedeemTokenView",
                        comment: ""
                    )
                )

                TextField(
                    String(
                        localized: "redeem_token_view_enter_token_manually_field_token_label",
                        defaultValue: "Token",
                        table: "RedeemTokenView",
                        comment: ""
                    ),
                    text: $token
                )
                    .focused($focusedField, equals: .ManuallyToken)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(
                                (focusedField == .ManuallyToken ? .yellow : Color(red: 209/255, green: 209/255, blue: 213/255)),
                                lineWidth: (focusedField == .ManuallyToken ? 2 : 1))
                    )

                VStack(alignment: .leading) {
                    Text(
                        String(
                            localized: "redeem_token_view_enter_token_manually_field_token_description",
                            defaultValue: "Please look for the token provided by the email and enter it in the field above",
                            table: "RedeemTokenView",
                            comment: ""
                        )
                    )
                        .foregroundColor(Color.gray)
                        .font(.caption)
                }

                Button(action: {
                    UIApplication.endEditing()
                    self.isManuallySOCPresented = false
                    Task {
                        do {
                            self.isInvaildTokenAlertPresented = !(try await EventStore.redeem(token: token))
                        } catch APIManager.LoadError.forbidden {
                            self.isHttp403AlertPresented = true
                        } catch {
                            self.isInvaildTokenAlertPresented = true
                        }
                    }
                }) {
                    HStack {
                        Spacer()
                        Text(
                            String(
                                localized: "redeem_token_view_enter_token_manually_continue_button",
                                defaultValue: "Continue",
                                table: "RedeemTokenView",
                                comment: ""
                            )
                        )
                            .padding(.vertical, 20)
                            .foregroundColor(Color.white)
                        Spacer()
                    }.background(.logo).cornerRadius(12)
                }
            }
        }
        .onChange(of: selectedPhotoItem) {
            Task {
                guard let data = try? await selectedPhotoItem?.loadTransferable(type: Data.self),
                      let ciImage = CIImage(data: data),
                      let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil),
                      let feature = detector.features(in: ciImage) as? [CIQRCodeFeature],
                      let token = feature.first?.messageString
                else { self.isNoQRCodeAlertPresented = true; return }
                do {
                    let result = try await EventStore.redeem(token: token)
                    self.isInvaildTokenAlertPresented = !result
                } catch APIManager.LoadError.forbidden {
                    self.isHttp403AlertPresented = true
                } catch { self.isInvaildTokenAlertPresented = true }
            }
        }
    }

    /// Handles the result of a QR code scan operation
    private func handleScan(result: Result<ScanResult, ScanError>) {
        // Hide the camera interface immediately after scan
        self.isCameraSOCPresented = false

        switch result {
        case .success(let result):
            // Extract token from scanned string (handle both direct tokens and URL parameters)
            var token = result.string
            if let urlComponents = URLComponents(string: token),
               let queryItems = urlComponents.queryItems,
               let tokenValue = queryItems.first(where: { $0.name == "token" })?.value {
                token = tokenValue
            }

            Task {
                do {
                    let result = try await EventStore.redeem(token: token)
                    DispatchQueue.main.async {
                        self.isInvaildTokenAlertPresented = !result
                    }
                } catch APIManager.LoadError.forbidden {
                    DispatchQueue.main.async {
                        self.isHttp403AlertPresented = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isInvaildTokenAlertPresented = true
                    }
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.isInvaildTokenAlertPresented = true
            }
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    enum Field: Hashable {
        case ManuallyToken
    }
}

#if DEBUG
struct RedeemTokenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RedeemTokenView()
                .environmentObject(OPassStore.mock().event!)
                .navigationTitle("Ticket")
        }
    }
}
#endif
