class Maps::DailyRandom
  def initialize(map_count:)
    @map_count = map_count
  end

  def call
    seed = Digest::MD5.hexdigest(Date.today.to_s).to_i(16) # Generate a seed based on the current date
    map_ids = Map.pluck(:id)
    random_ids = map_ids.shuffle(random: Random.new(seed)).first(@map_count)
    Map.where(id: random_ids).includes(:image_attachment, :user)
  end
end
