# Seeds for Adam's Journal
#
# Run with: mix run priv/repo/seeds.exs

alias AdamJournal.{Repo, Post, AgentConfig}

# --- Admin User ---

case Sigil.Auth.register(%{email: "admin@example.com", password: "admin123"}) do
  {:ok, _user} -> IO.puts("✓ Created admin user: admin@example.com / admin123")
  {:error, _} -> IO.puts("· Admin user already exists")
end

# --- Blog Posts (loaded from JSON bundled in priv/data/) ---

blog_posts_path =
  cond do
    # Try :code.priv_dir (works in dev and most releases)
    match?({:ok, _}, :code.priv_dir(:adam_journal) |> then(&{:ok, &1})) &&
      File.exists?(Path.join(:code.priv_dir(:adam_journal), "data/blog_posts.json")) ->
      Path.join(:code.priv_dir(:adam_journal), "data/blog_posts.json")

    # Try Application.app_dir (works in releases)
    function_exported?(Application, :app_dir, 2) &&
      File.exists?(Application.app_dir(:adam_journal, "priv/data/blog_posts.json")) ->
      Application.app_dir(:adam_journal, "priv/data/blog_posts.json")

    # Try relative to this seeds file (fallback)
    File.exists?(Path.join([__DIR__, "..", "data", "blog_posts.json"])) ->
      Path.join([__DIR__, "..", "data", "blog_posts.json"])

    true ->
      nil
  end

IO.puts("Blog posts path: #{inspect(blog_posts_path)}")

if blog_posts_path && File.exists?(blog_posts_path) do
  posts =
    blog_posts_path
    |> File.read!()
    |> Jason.decode!()
    |> Enum.map(fn post ->
      {:ok, published_at, _} = DateTime.from_iso8601(post["date_published"])
      published_at = DateTime.truncate(published_at, :second)

      # JSON posts have empty tags — assign based on content
      tags_map = %{
        "unlocking-the-art-of-closing" => ["sales", "strategy"],
        "developing-high-performance-teams" => ["leadership", "teams"],
        "why-companies-lose-their-speed" => ["strategy", "systems"],
        "nature-doesn-t-scale-through-force" => ["systems", "nature"],
        "hire-for-jobs-to-be-done" => ["AI", "teams", "strategy"],
        "the-most-essential-human-traits" => ["AI", "leadership"],
        "the-paradox-of-conviction" => ["strategy", "leadership"],
        "go-monthly" => ["strategy", "work"],
        "frame-floor-focus" => ["strategy", "systems"],
        "what-leadership-quietly-demands" => ["leadership"]
      }

      slug = post["slug"] || ""

      tags =
        Enum.find_value(tags_map, [], fn {key, val} ->
          if String.contains?(slug, key), do: val
        end)

      %{
        title: post["title"],
        slug: post["slug"],
        body: post["content"],
        tags: tags,
        published: true,
        published_at: published_at
      }
    end)

  for post_attrs <- posts do
    case Repo.get_by(Post, slug: post_attrs.slug) do
      nil ->
        %Post{}
        |> Post.changeset(post_attrs)
        |> Repo.insert!()

        IO.puts("✓ Created post: #{post_attrs.title}")

      _existing ->
        IO.puts("· Post exists: #{post_attrs.title}")
    end
  end
else
  IO.puts("⚠ Blog posts JSON not found at #{blog_posts_path}, skipping post seeds")
end

# --- Agent Configs ---

agents = [
  %{
    name: "Blog Assistant",
    slug: "blog-assistant",
    system_prompt: """
    You are a friendly assistant for Adam's Journal, a personal blog about AI, strategy, and systems.

    You can search blog posts to help answer questions about the author's writing. When you find relevant posts, reference them by title and share key ideas.

    Be concise and thoughtful. Match the tone of the blog — reflective, clear, and honest. Keep responses to 2-3 short paragraphs at most.

    If someone asks about a topic not covered in the blog, be honest about it and offer to help in other ways.
    """,
    model: "claude-sonnet-4-20250514",
    active: true,
    tools: []
  },
  %{
    name: "Scheduler",
    slug: "scheduler",
    system_prompt: """
    You are the scheduling assistant. Your job is to help people who want
    to connect set up a meeting.

    ## Your Process

    1. When someone expresses interest in connecting , warmly
       acknowledge their interest.

    2. Before checking availability, you MUST learn three things:
       - Their **name**
       - **What they'd like to discuss** 
       - **How they found** the blog (optional — ask naturally, don't demand)

       Ask these conversationally, not as a checklist. It's okay to gather
       this over a few messages.

    3. **Sales pitch detection**: If the person's topic is clearly a sales
       pitch, product demo request, or cold outreach, politely decline:
       "Thanks for your interest, but We aren't taking sales meetings through
       the blog at this time. Feel free to reach out via email for business
       inquiries." Do NOT check the calendar for sales pitches.

    4. Once you have the name and a genuine topic, use the `check_calendar`
       tool to find available slots. Present 3 options.

    5. After the user picks a time, ask for their **email address** so you
       can send the calendar invite.

    6. Use the `book_meeting` tool with all the collected information.

    7. Confirm the booking with a friendly summary.

    ## Tone

    Be warm, professional, and concise. Be welcoming
    but respect his time. Keep messages short and conversational.

    ## Important

    - Meetings are 30 minutes
    - Only offer times from the `check_calendar` tool results
    - Never fabricate availability
    - If the calendar tool shows no availability, apologize and suggest
      they try again next week
    """,
    model: "claude-sonnet-4-20250514",
    active: true,
    tools: ["check_calendar", "book_meeting"]
  }
]

for agent_attrs <- agents do
  case Repo.get_by(AgentConfig, slug: agent_attrs.slug) do
    nil ->
      %AgentConfig{}
      |> AgentConfig.changeset(agent_attrs)
      |> Repo.insert!()

      IO.puts("✓ Created agent: #{agent_attrs.name}")

    _existing ->
      IO.puts("· Agent exists: #{agent_attrs.name}")
  end
end

IO.puts("\n✓ Seeds complete!")
