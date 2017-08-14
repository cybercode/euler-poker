class Debug
  def self.call(*args)
    return unless ENV['DEBUG']

    $stderr.puts(args.map { |a| "DEBUG #{a}"})
  end
end
