for i in *.mp[34]
do 
name=`echo $i | sed 's/ ........ default//'`
mv "$i" "$name"
done

