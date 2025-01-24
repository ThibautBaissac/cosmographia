puts "Starting to empty the database..."

# Define models in the order that respects dependencies
models_in_order = [
  # Active Storage
  ActiveStorage::VariantRecord,
  ActiveStorage::Attachment,
  ActiveStorage::Blob,

  # Solid
  SolidCache::Entry,
  SolidQueue::BlockedExecution,
  SolidQueue::ClaimedExecution,
  SolidQueue::FailedExecution,
  SolidQueue::Job,
  SolidQueue::Pause,
  SolidQueue::Process,
  SolidQueue::ReadyExecution,
  SolidQueue::RecurringExecution,
  SolidQueue::RecurringTask,
  SolidQueue::ScheduledExecution,
  SolidQueue::Semaphore,

  # Visualization Related
  Visualization::Comment,
  VisualizationSoftware,
  Visualization,

  # User Related
  UserChallenge,
  UserSoftware,
  User,

  # Challenges
  Challenge::Discussion,
  Challenge,

  # Pay Related
  Pay::PaymentMethod,
  Pay::Charge,
  Pay::Subscription,
  Pay::Customer,

  # Billing Plans
  Billing::PlanVersion,
  Billing::Plan,

  # Feedback and Sources
  Feedback,
  Source,

  # Software
  Software
]

ActiveRecord::Base.transaction do
  models_in_order.each do |model|
    if model.table_exists?
      puts "Destroying all records of #{model.name}..."
      model.destroy_all
    else
      puts "Skipping #{model.name} as the table does not exist."
    end
  end
end

puts "All tables have been emptied successfully."
