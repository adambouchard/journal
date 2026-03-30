defmodule AdamJournal.Components.SideNav do
  @moduledoc "Shared sidebar navigation component used by HomeLive and ChatLive."
  import Sigil.HTML, only: [escape: 1]

  def render(assigns) do
    site_name = AdamJournal.Settings.get("site_name")
    site_tagline = AdamJournal.Settings.get("site_tagline")

    active_tag = assigns[:active_tag]

    tags_html =
      Enum.map_join(assigns[:tags] || [], "", fn tag ->
        active_class =
          if tag == active_tag do
            "border-stone-900 dark:border-stone-100 bg-stone-900 dark:bg-stone-100 text-white dark:text-stone-900"
          else
            "border-stone-300 dark:border-stone-700 bg-stone-100 dark:bg-stone-900 text-stone-600 dark:text-stone-400 hover:border-stone-400 dark:hover:border-stone-600"
          end

        "<a href=\"/?tag=#{URI.encode(tag)}\" class=\"inline-flex items-center rounded-full border #{active_class} px-3 py-1 text-sm transition-colors\">#{escape(tag)}</a>"
      end)

    recent_posts_html =
      (assigns[:recent_posts] || [])
      |> Enum.take(3)
      |> Enum.map_join("\n", fn post ->
        "<a href=\"/entry/#{post.slug}\" class=\"block truncate text-sm text-stone-600 dark:text-stone-400 hover:text-stone-900 dark:hover:text-stone-200 transition-colors\">#{escape(post.title)}</a>"
      end)

    auth_link =
      if assigns[:current_user] do
        "<a href=\"/admin\" class=\"block text-xs text-stone-400 hover:text-stone-600 dark:hover:text-stone-300 transition-colors\">Admin</a>"
      else
        "<a href=\"/login\" class=\"block text-xs text-stone-400 hover:text-stone-600 dark:hover:text-stone-300 transition-colors\">Login</a>"
      end

    """
    <aside class="w-full lg:w-1/3 lg:max-w-md xl:max-w-lg border-b lg:border-b-0 lg:border-r border-stone-200 dark:border-stone-800 bg-stone-100/50 dark:bg-stone-900/40 lg:sticky lg:top-0 lg:h-screen lg:overflow-y-auto">
      <div class="px-6 py-8 lg:px-8 lg:py-10 flex flex-col min-h-full">
        <div class="space-y-8">
          <!-- Masthead -->
          <header class="pb-6 border-b border-stone-200 dark:border-stone-800">
            <a href="/" class="flex items-center gap-x-5">
              <img src="https://avatars.githubusercontent.com/u/362348?v=4" alt="" class="size-14 rounded-full ring-2 ring-stone-300 dark:ring-stone-700" />
              <div>
                <h3 class="text-base font-semibold tracking-tight text-stone-900 dark:text-stone-100">#{escape(site_name)}</h3>
                <p class="text-sm text-stone-500">#{escape(site_tagline)}</p>
              </div>
            </a>
          </header>

          <!-- AI Assistant -->
          <section>
            <a href="/chat/blog-assistant" class="group flex items-center gap-3 rounded-xl border border-stone-200 dark:border-stone-800 bg-white dark:bg-stone-900/50 px-4 py-3 hover:bg-stone-100 dark:hover:bg-stone-800/50 hover:border-stone-300 dark:hover:border-stone-700 transition-all">
              <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-stone-100 dark:bg-stone-800 text-base">💬</span>
              <div>
                <span class="text-sm font-medium text-stone-800 dark:text-stone-200 group-hover:text-stone-900 dark:group-hover:text-stone-100">AI Assistant</span>
              </div>
            </a>
          </section>

          <!-- Recent Entries -->
          <section>
            <h2 class="text-xs font-semibold uppercase tracking-widest text-stone-500 mb-3">Recent</h2>
            <div class="space-y-2">
              #{recent_posts_html}
            </div>
          </section>

          <!-- Tags -->
          <section>
            <h2 class="text-xs font-semibold uppercase tracking-widest text-stone-500 mb-3">Tags</h2>
            <div class="flex flex-wrap gap-2">
              #{tags_html}
            </div>
          </section>
        </div>

        <!-- Footer — pinned to bottom -->
        <footer class="pt-6 mt-auto border-t border-stone-200 dark:border-stone-800 flex items-center justify-between">
          <a href="https://github.com/sigilframework/sigil" target="_blank" class="block text-xs text-stone-400 hover:text-stone-600 dark:hover:text-stone-300 transition-colors">Made with ❤️ by Sigil Framework</a>
          <div>#{auth_link}</div>
        </footer>
      </div>
    </aside>
    """
  end

end
