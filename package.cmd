set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_65

cd D:\Temp\WorkTemp\ifsdate
call D:\Temp\WorkTemp\ELK\logstash-1.5.3\vendor\jruby\bin\gem.bat build D:\Temp\WorkTemp\ifsdate\logstash-filter-ifsdate.gemspec

cd D:\Temp\WorkTemp\ELK\logstash-1.5.3
call bin\plugin.bat install D:\Temp\WorkTemp\ifsdate\logstash-filter-ifsdate-2.0.2.gem

pause