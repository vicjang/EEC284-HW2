# ==========================================
#   EEC 284  HW-2
#
#     Dynamic programming for finding best
#       schedule with minimum buffer size
#
# ==========================================


# number of occurrences of each actors calculated in part a) manually
qG = Array[ 4, 6, 9, 12, 4 ]
produced = Array[ 3, 3, 4, 1 ]


# ----------------------------------------------
# A test sample from the reference paper
#qG = Array[ 147,147,98,28,32,160 ]
#produced = Array[ 1,2,2,8,5 ]
# ----------------------------------------------



# size of chain
n = qG.size

# array for $gcds's
$gcds = Array.new( n ) { Array.new( n, 0 ) }


qG.each_with_index do |x, index|
    $gcds[ index ][ index ] = x
    for j in index + 1 .. n - 1 do
        $gcds[ index ][ j ] = $gcds[ index ][ j - 1 ].to_int.gcd( qG[j] )
    end
end

# initialize subcosts array and $splitPositions array
subcosts = Array.new( n ) { Array.new( n ) }
$splitPositions =  Array.new( n ) { Array.new( n ) }

# initialize some values
subcosts.each_with_index do |x, index|
    subcosts[ index ][ index ] = 0
end


for chain_size in 2 .. n do
    for right in chain_size .. n do
        left = right - chain_size + 1
        min_cost = 1e10

        for i in 0 .. chain_size - 2 do
            split_cost = qG[ left + i - 1 ] * produced[ left + i - 1 ] / $gcds[ left - 1 ][ right - 1 ]
            total_cost = split_cost + subcosts[ left - 1 ][ left + i - 1 ] + subcosts[ left + i + 1 - 1 ][ right - 1 ]
            if( total_cost < min_cost )
                split = i
                min_cost = total_cost
            end
            subcosts[ left - 1 ][ right - 1 ] = min_cost
            $splitPositions[ left - 1 ][ right - 1 ] = split
        end
    end
end


#puts Subcosts
#str = $splitPositions.inspect.split("], ")
str = $splitPositions.inspect
str.gsub!( /], /, "]\n" )
str.gsub!( /\[\[/, "\[" )
str.gsub!( /\]\]/, "\]" )
str.gsub!( /nil/, " " )
puts str
puts "\n"

str = subcosts.inspect
str.gsub!( /], /, "]\n" )
str.gsub!( /\[\[/, "\[" )
str.gsub!( /\]\]/, "\]" )
str.gsub!( /nil/, " " )
puts str
puts "\n"

def ConvertSplits( l, r )
    if( l == r )
        return ?A.ord + l
    else
        s = $splitPositions[ l ][ r ]
        iL = $gcds[ l ][ l + s ] / $gcds[ l ][ r ]
        iR = $gcds[ l + s + 1 ][ r ] / $gcds[ l ][ r ]

        # Don't display 1 to reduce confusion
        if( iL == 1 )
            iL = ""
        end
        if( iR == 1 )
            iR = ""
        end

        return "(#{iL}" << ConvertSplits( l, l + s ) << ")(#{iR}" << ConvertSplits( l + s + 1, r ) << ")"
    end
end


# Sending 1 and n subtracted by 1 because my array starts from 0
# but the pseudo code that I followed has array starting from 1
output = ConvertSplits( 1 - 1, n - 1 )
puts output
puts "\n"

