puts "hello world"

languages = ["日本語", "英語", "スペイン語"]

x = 0

languages.each do |language|
  puts "#{language}を話せます"
  x = x + 1
  puts "#{x}"
end

def time1
    puts "timer1"
    sleep(2)
    rel = `ls -al`
    #puts rel
end
  
def time2
    puts "timer2"
    sleep(2)
    puts `ls -alt`
end

time1
time2

## Threadを利用した例
threads = []
threads << Thread.new { time1() }
threads << Thread.fork { time2() }
threads.each { |thr| thr.join }

begin 
    raise StandardError.new('error')
rescue => e
    puts e.message #=> error
    puts $!
    puts $@
ensure 
    puts "絶対実行" #=> 絶対実行
end