require 'rdoc/task'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'find'

desc 'Run tests'
task default: :test

desc 'Say hello'
task :hello do
  puts "Hello there. This is the 'hello' task."
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'Display inventory of all files'
task :inventory do
  Find.find(File.expand_path('.')) do |path|
    file_basename = File.basename(path)

    if FileTest.directory?(path)
      if file_basename.start_with?('.')
        Find.prune
      end
    else
      puts path unless file_basename.start_with?('.')
    end
  end
end

RDoc::Task.new do |doc|
  doc.main = 'README.md'
  doc.title = "TodoList Documentation"
  doc.rdoc_dir = 'doc'
  doc.rdoc_files = FileList.new %w(lib/**/*.rb)
end
