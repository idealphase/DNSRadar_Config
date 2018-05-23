require 'elasticsearch'
def filter(event)
    client = Elasticsearch::Client.new host: "localhost:9200"
    query = event.get("query")
    if query[0] == 'w' and query[1] == 'w' and query[2] == 'w' and query[3] == '.'
        query = query[4..-1]
    end
    if query[0] == '.'
        return []
    end
    if query[0] == 'c' and query[1] =='o' and query[2] =='.' and  query[3] =='u' and query[4] =='k' and  query[5] =='.'
        return []
    end
    if query[-12] == 'l' and query[-11] =='o' and query[-10] =='c' and query[-9] =='a' and query[-8]=='l' and query[-7]=='d' and query[-6]=='o' and query[-5]=='m' and query[-4]=='a' and query[-3] == 'i' and query[-2]=='n' and query[-1]=='.'
        return []
    end
    if query[0] == 'x' and query[1] =='n' and query[2] == '-' and query[3] =='-'
        return [event]
    end
    response = client.perform_request "GET","legitimate_domain_name/doc*/_count?q=domain:#{query[0...-1]}"
    if response.body["count"] > 0
        return []
    else
        response = client.perform_request "GET","domain_name_typosquatting/doc*/_count?q=domain:#{query[0...-1]}"
        if response.body["count"] > 0
            event.set("count_in_domain_name_typosquatting", response.body["count"])
            return [event]
        else
            return []
        end
    end
end
