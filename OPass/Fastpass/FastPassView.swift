//
//  FastPassView.swift
//  OPass
//
//  Created by 張智堯 on 2022/3/25.
//  2025 OPass.
//

import SwiftUI

struct FastPassView: View {

    // MARK: - Variables
    @EnvironmentObject var EventStore: EventStore
    @State private var isHttp403AlertPresented = false
    @State private var errorType: String? = nil

    // MARK: - Views
    var body: some View {
        VStack {
            if EventStore.token == nil {
                RedeemTokenView()
            } else {
                if errorType == nil {
                    if EventStore.attendee != nil {
                        ScenarioView()
                            .task {
                                do { try await EventStore.loadAttendee() } catch APIManager
                                    .LoadError.forbidden
                                {
                                    self.isHttp403AlertPresented = true
                                } catch {}
                            }
                    } else {
                        ProgressView(
                            String(
                                localized: "fast_pass_view_status_loading",
                                defaultValue: "Loading",
                                table: "FastPassView",
                                comment: "The loading status text on Fast Pass View"
                            )
                        )
                            .task {
                                do { try await EventStore.loadAttendee() } catch APIManager
                                    .LoadError.forbidden
                                {
                                    self.errorType = "http403"
                                } catch { self.errorType = "unknown" }
                            }
                    }
                } else {
                    ContentUnavailableView {
                        switch errorType! {
                        case "http403":
                            Label(
                                String(
                                    localized: "fast_pass_view_error_network_label",
                                    defaultValue: "Network Error",
                                    table: "FastPassView",
                                    comment: "The error label of network error (didn't connect to event-provided Wi-Fi) on the Fast Pass View."
                                ),
                                systemImage: "wifi.exclamationmark"
                            )
                        default:
                            Label(
                                String(
                                    localized: "fast_pass_view_error_default_label",
                                    defaultValue: "Something Went Wrong",
                                    table: "FastPassView",
                                    comment: "The default error label (network status error or wrong event) on the Fast Pass View."
                                ),
                                systemImage: "exclamationmark.triangle.fill"
                            )
                        }
                    } description: {
                        switch errorType! {
                        case "http403":
                            Text(
                                String(
                                    localized: "fast_pass_view_error_network_description",
                                    defaultValue: "Please connect to the Wi-Fi provided by event",
                                    table: "FastPassView",
                                    comment: "The error description of network error (didn't connect to event-provided Wi-Fi) on the Fast Pass View."
                                )
                            )
                        default:
                            Text(
                                String(
                                    localized: "fast_pass_view_error_default_description",
                                    defaultValue: "Check your network status or select a new event.",
                                    table: "FastPassView",
                                    comment: "The default error description (network status error or wrong event) on the Fast Pass View."
                                )
                            )
                        }
                    } actions: {
                        Button(
                            String(
                                localized: "fast_pass_view_action_try_again_button",
                                defaultValue: "Try Again",
                                table: "FastPassView",
                                comment: "The try again action button on the Fast Pass View."
                            )
                        ) {
                            self.errorType = nil
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    if let displayText = EventStore.config.feature(.fastpass)?.title {
                        Text(displayText.localized()).font(.headline)
                    }
                    Text(EventStore.config.title.localized())
                        .font(.caption).foregroundColor(.gray)
                }
            }
        }
        .http403Alert(isPresented: $isHttp403AlertPresented)
    }
}

#if DEBUG
    struct FastPassView_Previews: PreviewProvider {
        static var previews: some View {
            FastPassView()
                .environmentObject(OPassStore.mock().event!)
        }
    }
#endif
