Function SQLServerStaleIndexScan {
    Param(
        [Parameter(Mandatory=$true)] [string] $serverName,
        [Parameter(Mandatory=$true)] [string] $databaseName
    )
    begin{
        Write-Host "Scanning for stale indexes in database '$databaseName'..." -BackgroundColor Blue -ForegroundColor White
    }
    process {
        $serverName = $serverName.Replace("'", "")
        $serverName = $serverName.Trim()

        $databaseName = $databaseName.Replace("'", "")
        $databaseName = $databaseName.Trim()

        $connection = new-object System.Data.SqlClient.SQLConnection("Data Source=$serverName;Integrated Security=SSPI;Initial Catalog=$databaseName");
        $baseQuery = "SELECT
	CONCAT(schemas.name,'.',objects.name) AS SchemaTable,
	indexes.name AS IndexName,
	indexes.type_desc AS IndexType,
	indexes.is_primary_key AS PKIndex,
	indexes.is_unique_constraint AS UniqueConstraint,
	indexes.is_disabled AS IsDisabled
FROM
	sys.indexes
	INNER JOIN sys.objects
		ON sys.indexes.object_id = sys.objects.object_id
	INNER JOIN sys.schemas
		ON objects.schema_id = schemas.schema_id

WHERE
	indexes.index_id NOT IN
		(
			SELECT
				index_id
			FROM
				sys.dm_db_index_usage_stats AS usage
				INNER JOIN sys.databases
					ON usage.database_id = databases.database_id
			WHERE
				indexes.object_id = usage.object_id
				AND indexes.index_id = usage.index_id
				AND databases.name = '$databaseName'
		)
	AND objects.type = 'U'
ORDER BY
	objects.type_desc,
	objects.name,
	indexes.name;"

        $completedQuery = new-object System.Data.SqlClient.SQLCommand($baseQuery, $connection)

        $connection.Open()

        $reader = $completedQuery.ExecuteReader()
        
        $results = @()

        while ($reader.Read())
        {
            $row = @{}
            for ($i = 1; $i -lt $reader.FieldCount; $i++)
            {
                $row[$reader.GetName($i)] = $reader.GetValue($i)
            }
            $results += new-object psobject -property $row            
        }

        $connection.Close()

        if($results){
            $results | Format-Table -AutoSize
            $BGcolor = "Green"
            $FGcolor = "Black"
        } else {
            Write-Host "No stale indexes found for database '$databaseName'. Please ensure the database name is correct." -BackgroundColor Yellow -ForegroundColor Black
            $BGcolor = "Red"
            $FGcolor = "White"
        }
    }
    End {
        Write-Host "Finished checking for stale indexes in database '$databaseName'." -BackgroundColor $BGcolor -ForegroundColor $FGcolor
    }
    
}

SQLServerStaleIndexScan