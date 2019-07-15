set :ex_durations, {}

set :finish_stopwatch, lambda { |durations|
  puts durations
}

namespace :stopwatch do
  desc 'Finish stopwatch'
  task :finish do
    run_locally do
      info 'Finishing stopwatch'
      fetch(:finish_stopwatch).call(fetch(:ex_durations))
    end
  end
end

def measure_duration(task)
  define_start(task)
  define_stop(task)

  before task, "stopwatch:#{ task }_start"
  after task, "stopwatch:#{ task }_stop"
end

def define_start(task)
  namespace :stopwatch do
    desc 'Start stopwatch'
    task "#{ task }_start" do
      run_locally do
        debug "Starting stopwatch for #{ task }"
        set "#{ task }_timer_started_at", Time.now
      end
    end
  end
end

def define_stop(task)
  namespace :stopwatch do
    desc 'Stop stopwatch'
    task "#{ task }_stop" do
      run_locally do
        debug "Stopping stopwatch for #{ task }"

        started_at = fetch("#{ task }_timer_started_at")
        durations = fetch(:ex_durations)
        durations[task] = Time.now - started_at

        set :ex_durations, durations
      end
    end
  end
end
