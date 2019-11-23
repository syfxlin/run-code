# == Schema Information
#
# Table name: submissions
#
#  id                                         :integer          not null, primary key
#  source_code                                :text
#  language_id                                :integer
#  stdin                                      :text
#  expected_output                            :text
#  stdout                                     :text
#  status_id                                  :integer
#  created_at                                 :datetime
#  finished_at                                :datetime
#  time                                       :decimal(, )
#  memory                                     :integer
#  stderr                                     :text
#  token                                      :string
#  number_of_runs                             :integer
#  cpu_time_limit                             :decimal(, )
#  cpu_extra_time                             :decimal(, )
#  wall_time_limit                            :decimal(, )
#  memory_limit                               :integer
#  stack_limit                                :integer
#  max_processes_and_or_threads               :integer
#  enable_per_process_and_thread_time_limit   :boolean
#  enable_per_process_and_thread_memory_limit :boolean
#  max_file_size                              :integer
#  compile_output                             :text
#  exit_code                                  :integer
#  exit_signal                                :integer
#  message                                    :text
#  wall_time                                  :decimal(, )
#  compiler_options                           :string
#  command_line_arguments                     :string
#
# Indexes
#
#  index_submissions_on_token  (token)
#

class Submission < ApplicationRecord
  validates :source_code, :language_id, presence: true
  validates :number_of_runs,
            numericality: { greater_than: 0, less_than_or_equal_to: Config::MAX_NUMBER_OF_RUNS }
  validates :cpu_time_limit,
            numericality: { greater_than: 0, less_than_or_equal_to: Config::MAX_CPU_TIME_LIMIT }
  validates :cpu_extra_time,
            numericality: { greater_than: 0, less_than_or_equal_to: Config::MAX_CPU_EXTRA_TIME }
  validates :wall_time_limit,
            numericality: { greater_than: 0, less_than_or_equal_to: Config::MAX_WALL_TIME_LIMIT }
  validates :memory_limit,
            numericality: { greater_than: 0, less_than_or_equal_to: Config::MAX_MEMORY_LIMIT }
  validates :stack_limit,
            numericality: { greater_than: 0, less_than_or_equal_to: Config::MAX_STACK_LIMIT }
  validates :max_processes_and_or_threads,
            numericality: { greater_than: 0, less_than_or_equal_to: Config::MAX_MAX_PROCESSES_AND_OR_THREADS }
  validates :enable_per_process_and_thread_time_limit,
            inclusion: { in: [false], message: "this option cannot be enabled" },
            unless: "Config::ALLOW_ENABLE_PER_PROCESS_AND_THREAD_TIME_LIMIT"
  validates :enable_per_process_and_thread_memory_limit,
            inclusion: { in: [false], message: "this option cannot be enabled" },
            unless: "Config::ALLOW_ENABLE_PER_PROCESS_AND_THREAD_MEMORY_LIMIT"
  validates :max_file_size,
            numericality: { greater_than: 0, less_than_or_equal_to: Config::MAX_MAX_FILE_SIZE }
  validates :compiler_options, length: { maximum: 128 }
  validates :command_line_arguments, length: { maximum: 128 }
  validate :language_existence, :compiler_options_allowed, :command_line_arguments_allowed

  before_create :generate_token
  before_validation :set_defaults

  enumeration :status

  default_scope { order(created_at: :desc) }

  self.per_page = 20

  def source_code
    @decoded_source_code ||= Base64Service.decode(self[:source_code])
  end

  def source_code=(value)
    super(value)
    self[:source_code] = Base64Service.encode(self[:source_code])
  end


  def stdin
    @decoded_stdin ||= Base64Service.decode(self[:stdin])
  end

  def stdin=(value)
    super(value)
    self[:stdin] = Base64Service.encode(self[:stdin])
  end


  def stdout
    @decoded_stdout ||= Base64Service.decode(self[:stdout])
  end

  def stdout=(value)
    super(value)
    self[:stdout] = Base64Service.encode(self[:stdout])
  end


  def expected_output
    @decoded_expected_output ||= Base64Service.decode(self[:expected_output])
  end

  def expected_output=(value)
    super(value)
    self[:expected_output] = Base64Service.encode(self[:expected_output])
  end


  def stderr
    @decoded_stderr ||= Base64Service.decode(self[:stderr])
  end

  def stderr=(value)
    super(value)
    self[:stderr] = Base64Service.encode(self[:stderr])
  end


  def compile_output
    @decoded_compile_output ||= Base64Service.decode(self[:compile_output])
  end

  def compile_output=(value)
    super(value)
    self[:compile_output] = Base64Service.encode(self[:compile_output])
  end


  def language
    @language ||= Language.find(language_id)
  end


  def status
    Status.find_by(id: status_id)
  end

  def status=(status)
    self.status_id = status.id
  end

  private

  def language_existence
    if language_id && !Language.exists?(language_id)
      errors.add(:language_id, "language with id #{language_id} doesn't exist")
    end
  end

  def compiler_options_allowed
    return if compiler_options.blank?

    unless Config::ENABLE_COMPILER_OPTIONS
      errors.add(:compiler_options, "setting compiler options is not allowed")
      return
    end

    if Language.exists?(language_id) && language.compile_cmd.nil?
      errors.add(:compiler_options, "setting compiler options is only allowed for compiled languages")
      return
    end

    @@allowed_languages ||= Config::ALLOWED_LANGUAGES_FOR_COMPILER_OPTIONS.collect{ |s| s + " " }
    if Language.exists?(language_id) && @@allowed_languages.present? && !language.name.starts_with?(*@@allowed_languages)
      @@allowed_languages_message ||= @@allowed_languages.size > 1 ? @@allowed_languages[0..-2].collect{ |s| s.strip }.join(", ") + " and " + @@allowed_languages[-1].strip : @@allowed_languages[0].strip
      errors.add(:compiler_options, "setting compiler options is only allowed for #{@@allowed_languages_message}")
    end
  end

  def command_line_arguments_allowed
    return if command_line_arguments.blank?

    unless Config::ENABLE_COMMAND_LINE_ARGUMENTS
      errors.add(:command_line_arguments, "setting command line arguments is not allowed")
    end
  end

  def generate_token
    begin
      self.token = SecureRandom.uuid
    end while self.class.exists?(token: token)
  end

  def set_defaults
    self.status ||= Status.queue
    self.number_of_runs ||= Config::NUMBER_OF_RUNS
    self.cpu_time_limit ||= Config::CPU_TIME_LIMIT
    self.cpu_extra_time ||= Config::CPU_EXTRA_TIME
    self.wall_time_limit ||= Config::WALL_TIME_LIMIT
    self.memory_limit ||= Config::MEMORY_LIMIT
    self.stack_limit ||= Config::STACK_LIMIT
    self.max_processes_and_or_threads ||= Config::MAX_MAX_PROCESSES_AND_OR_THREADS
    self.enable_per_process_and_thread_time_limit ||= Config::ENABLE_PER_PROCESS_AND_THREAD_TIME_LIMIT
    self.enable_per_process_and_thread_memory_limit ||= Config::ENABLE_PER_PROCESS_AND_THREAD_MEMORY_LIMIT
    self.max_file_size ||= Config::MAX_FILE_SIZE
  end
end
