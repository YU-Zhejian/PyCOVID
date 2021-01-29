BEGIN{
	FS=",";OFS="\t"
}
{
	printf "INSERT INTO Country_CRD (Date, Country, Confirmed, Recovered, Deaths) VALUES ('%s','%s',%d,%d,%d );\n", $1, $2, $3, $4, $5
}
