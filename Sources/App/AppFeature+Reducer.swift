//
//  AppFeature+Reducer.swift
//
//
//  Created by ErrorErrorError on 4/6/23.
//
//

import Architecture
import ComposableArchitecture
import DatabaseClient
import Discover
import ModuleLists
import Repos
import Search
import Settings
import VideoPlayer

public extension AppFeature.Reducer {
    @ReducerBuilder<State, Action>
    var body: some ReducerOf<Self> {
        Scope(state: \.settings.userSettings, action: /Action.InternalAction.appDelegate) {
            AppDelegateFeature.Reducer()
        }

        Reduce { state, action in
            switch action {
            case .view(.didAppear):
                break

            case let .view(.didSelectTab(tab)):
                if state.selected == tab {
                    switch tab {
                    case .discover:
                        state.discover.screens.removeAll()
                    case .repos:
                        state.repos.$repos.selected = nil
                    case .search:
                        state.search.screens.removeAll()
                    case .settings:
                        break
                    }
                } else {
                    state.selected = tab
                }

            case .internal(.appDelegate):
                break

            case let .internal(.discover(.delegate(.playbackVideoItem(_, repoModuleID, playlist, group, paging, itemId)))),
                 let .internal(.search(.delegate(.playbackVideoItem(_, repoModuleID, playlist, group, paging, itemId)))):
                let effect = state.videoPlayer?.clearForNewPlaylistIfNeeded(
                    repoModuleID: repoModuleID,
                    playlist: playlist,
                    group: group,
                    page: paging,
                    episodeId: itemId
                )
                .map { Action.internal(.videoPlayer(.presented($0))) }

                if let effect {
                    return effect
                } else {
                    state.videoPlayer = .init(
                        repoModuleID: repoModuleID,
                        playlist: playlist,
                        contents: .init(),
                        group: group,
                        page: paging,
                        episodeId: itemId
                    )
                }

            case .internal(.discover):
                break

            case .internal(.repos):
                break

            case .internal(.search):
                break

            case .internal(.settings):
                break

            case .internal(.videoPlayer):
                break
            }
            return .none
        }
        .ifLet(\.$videoPlayer, action: /Action.internal .. Action.InternalAction.videoPlayer) {
            VideoPlayerFeature.Reducer()
        }

        Scope(state: \.discover, action: /Action.InternalAction.discover) {
            DiscoverFeature.Reducer()
        }

        Scope(state: \.repos, action: /Action.InternalAction.repos) {
            ReposFeature.Reducer()
        }

        Scope(state: \.search, action: /Action.InternalAction.search) {
            SearchFeature.Reducer()
        }

        Scope(state: \.settings, action: /Action.InternalAction.settings) {
            SettingsFeature.Reducer()
        }
    }
}
