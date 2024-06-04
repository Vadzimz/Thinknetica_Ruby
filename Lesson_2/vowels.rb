wovels = ["a","e","i","o","u","y"]
("a".."z").each.with_index(1).to_h.select{|k,v| wovels.include?(k)}.each{|k, v| puts "#{k}: #{v}"}
