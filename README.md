# Capistrano::Stopwatch

`Capistrano::Stopwatch` is a gem to measure the execution time of each Capistrano tasks. `Capistrano::Stopwatch` requires Capistrano v3 or above.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-stopwatch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-stopwatch

## Usage

Takes four simple steps to run `Capistrano::Stopwatch` on your environment.

### 1. Require `Capistrano::Stopwatch` in Capfile

```ruby
# Capfile
require 'capistrano-stopwatch'
```

### 2. Specify the tasks you want to measure 

Right now, you need to manually specify tasks you want to measure execution time. All you need to do is just call `measure_duration` method in `config/deploy.rb` and hand it name of tasks.    

```ruby
# config/deploy.rb
['deploy:starting', 'deploy:updating'].each do |n|
  measure_duration(n)
end
```

### 3. Specify when to finish

Specify when to run `stopwatch:finish` task and execute `finish_stopwatch` lambda function. Usually, it is safe to run `stopwatch:finish` after the very last task in your Capistrano deploy flow.    


```ruby
# config/deploy.rb
after 'test:stop', 'stopwatch:finish'
```

### 4. Specify how to handle the output

Override `finish_stopwatch` and specify how to handle the output, which is a hash of task name and execution time. By default, `finish_stopwatch` simply prints the output to stdout.

```ruby
# config/deploy.rb
set :finish_stopwatch, lambda { |durations|
  File.open("durations.json", "w") {|f| f.puts(durations.to_json) }
}
```

## Example

```ruby
# Capfile
require 'capistrano-stopwatch'
```

```ruby
# config/deploy.rb
require 'json'

set :finish_stopwatch, lambda { |durations|
  File.open("durations.json", "w") {|f| f.puts(durations.to_json) }
  puts durations
}

namespace :example do
  task :first do
    run_locally do
      info 'Running first task'
      sleep 1
    end
  end

  task :second do
    run_locally do
      info 'Running second task'
      sleep 2
    end
  end

  task :third do
    run_locally do
      info 'Running third task'
      sleep 3
    end
  end
end

['example:first', 'example:second', 'example:third'].each do |task|
  measure_duration(task)
end

after 'example:third', 'stopwatch:finish'
```

```bash
$ bundle ex cap development example:first example:second example:third
00:00 example:first
      Running first task
00:01 example:second
      Running second task
00:03 example:third
      Running third task
00:06 stopwatch:finish
      Finishing stopwatch
{"example:first"=>1.001629, "example:second"=>2.002746, "example:third"=>3.004129}

$ cat durations.json
{"example:first":1.001246,"example:second":2.004474,"example:third":3.00379}
```

## Other options

### CloudWatch Logs Insights

[AWS CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html) might be another good option to gether information about task execution time, even though you need to set how to parse Capistrano logs.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shuheiktgw/capistrano-stopwatch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Capistrano::Stopwatch project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/shuheiktgw/capistrano-stopwatch/blob/master/CODE_OF_CONDUCT.md).
