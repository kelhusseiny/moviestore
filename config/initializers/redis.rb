$redis = Redis.new(:driver => :hiredis)
$redis.set "1", [1,2,3,4,5]
