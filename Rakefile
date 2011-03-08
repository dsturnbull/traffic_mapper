HADOOP_HOME='/Users/dave/Downloads/hadoop-0.21.0'
IF='en0'

EXE="#{HADOOP_HOME}/bin/hadoop"
JAR="#{HADOOP_HOME}/mapred/contrib/streaming/hadoop-0.21.0-streaming.jar"

def quietly(cmd)
  system("#{cmd} > /dev/null 2> /dev/null")
end

def hdfs_rm_rf(path)
  quietly "#{EXE} fs -rmr #{path}"
end

def hdfs_mkdir(path)
  quietly "#{EXE} fs -mkdir #{path}"
end

def hdfs_put(srcs, dest)
  srcs = [srcs] if srcs.is_a?(String)
  system "#{EXE} fs -put #{srcs.join(' ')} #{dest}"
end

def hdfs_exists?(path)
  quietly "#{EXE} fs -ls #{path}"
end

def hdfs_get(path)
  `#{EXE} fs -get #{path} -`
end

def split_data(data, num, input_dir, &block)
  ts = []
  (1 .. num).each do
    t = Tempfile.new(`uuid`.strip)
    ts << t
  end

  data.each_with_index do |datum, i|
    k = i % num
    datum = yield datum if block_given?
    ts[k] << datum << "\n"
  end

  hdfs_rm_rf input_dir
  hdfs_mkdir input_dir

  ts.each { |t| t.close }
  hdfs_put ts.map(&:path), input_dir
  ts.each { |t| File.unlink(t.path) }
end

load 'collect/Rakefile'
load 'trace/Rakefile'
load 'map/Rakefile'
load 'visualise/Rakefile'

task :default do
  Rake.application.options.show_task_pattern = //
  Rake.application.display_tasks_and_comments
end
