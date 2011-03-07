require 'benchmark'
require 'redis'
require 'yaml'
require 'json'

N = 10000

Benchmark.bm do |r|
  @redis = Redis.new
  @serialize_me = { :lol => 'test', "ohai" => 'llllll', :array => [12,321,231,23, { :hi => 'hej'}]}

  r.report("YAML Save") do
    puts 'Yaml'
    puts YAML.dump(@serialize_me).length

    N.times do |n|
      @redis.set "yaml-#{n}", YAML.dump(@serialize_me)
    end
  end

  r.report("YAML Load") do
    N.times do |n|
      YAML.load(@redis.get "yaml-#{n}")
    end
  end

  r.report("Marshal Save") do 
    puts 'Marshal'
    puts Marshal.dump(@serialize_me).length

    N.times do |n|
      @redis.set "marshal-#{n}", Marshal.dump(@serialize_me)
    end
  end

  r.report("Marshal Load") do
    N.times do |n|
      Marshal.load(@redis.get "marshal-#{n}")
    end
  end

  r.report("JSON Save") do
    puts 'JSON'
    puts JSON.dump(@serialize_me).length

    N.times do |n|
      @redis.set "json-#{n}", JSON.dump(@serialize_me)
    end
  end

  r.report("JSON Load") do
    N.times do |n|
      JSON.load(@redis.get "json-#{n}")
    end
  end
end

# N = 10000
#       user     system      total        real
# YAML Save  1.170000   0.160000   1.330000 (  1.444772)
# YAML Load  0.560000   0.130000   0.690000 (  0.781064)
# Marshal Save  0.290000   0.140000   0.430000 (  0.527284)
# Marshal Load  0.260000   0.160000   0.420000 (  0.507964)
# JSON Save  0.670000   0.170000   0.840000 (  0.970764)
# JSON Load  0.310000   0.190000   0.500000 (  0.568105
#
# N = 100000
#       user     system      total        real
# YAML Save  1.170000   0.160000   1.330000 (  1.444772)
# YAML Load  0.560000   0.130000   0.690000 (  0.781064)
# Marshal Save  0.290000   0.140000   0.430000 (  0.527284)
# Marshal Load  0.260000   0.160000   0.420000 (  0.507964)
# JSON Save  0.670000   0.170000   0.840000 (  0.970764)
# JSON Load  0.310000   0.190000   0.500000 (  0.568105

