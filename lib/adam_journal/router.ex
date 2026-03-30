defmodule AdamJournal.Router do
  use Sigil.Router

  # Public
  live "/", AdamJournal.HomeLive, layout: {AdamJournal.Layout, :app}
  live "/entry/:slug", AdamJournal.EntryLive, layout: {AdamJournal.Layout, :app}
  live "/chat", AdamJournal.ChatLive, layout: {AdamJournal.Layout, :app}
  live "/chat/:slug", AdamJournal.ChatLive, layout: {AdamJournal.Layout, :app}

  # Auth
  live "/login", AdamJournal.LoginLive, layout: {AdamJournal.Layout, :app}

  post "/auth/login" do
    AdamJournal.AuthController.login(conn, [])
  end

  post "/auth/logout" do
    AdamJournal.AuthController.logout(conn, [])
  end

  # Uploads
  post "/admin/uploads" do
    AdamJournal.UploadController.upload(conn, [])
  end

  # Admin (protected)
  live "/admin", AdamJournal.Admin.DashboardLive, auth: true, layout: {AdamJournal.Layout, :admin}

  live "/admin/conversations", AdamJournal.Admin.ConversationsLive, auth: true, layout: {AdamJournal.Layout, :admin}
  live "/admin/conversations/:id", AdamJournal.Admin.ConversationsLive, auth: true, layout: {AdamJournal.Layout, :admin}

  live "/admin/posts", AdamJournal.Admin.PostsLive, auth: true, layout: {AdamJournal.Layout, :admin}
  live "/admin/posts/new", AdamJournal.Admin.PostsLive, auth: true, layout: {AdamJournal.Layout, :admin}
  live "/admin/posts/:id/edit", AdamJournal.Admin.PostsLive, auth: true, layout: {AdamJournal.Layout, :admin}

  live "/admin/agents", AdamJournal.Admin.AgentsLive, auth: true, layout: {AdamJournal.Layout, :admin}
  live "/admin/agents/new", AdamJournal.Admin.AgentsLive, auth: true, layout: {AdamJournal.Layout, :admin}
  live "/admin/agents/:id/edit", AdamJournal.Admin.AgentsLive, auth: true, layout: {AdamJournal.Layout, :admin}

  live "/admin/tools", AdamJournal.Admin.ToolsLive, auth: true, layout: {AdamJournal.Layout, :admin}

  live "/admin/settings", AdamJournal.Admin.SettingsLive, auth: true, layout: {AdamJournal.Layout, :admin}

  sigil_routes()
end
