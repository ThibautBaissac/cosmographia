class Visualizations::DailyRandomSelector
  def initialize(count: 6, scope: Visualization.all)
    @count = count
    @scope = scope
  end

  def call
    visualization_ids = fetch_visualization_ids
    visualization_ids.shuffle(random: seeded_random).first(@count)
  end

  private

  def fetch_visualization_ids
    @scope.pluck(:id)
  end

  def seeded_random
    seed = generate_seed
    Random.new(seed)
  end

  def generate_seed
    Digest::MD5.hexdigest(@date.to_s).to_i(16)
  end
end
