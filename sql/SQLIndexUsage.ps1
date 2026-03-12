Function SQLServerIndexUsage {
    Param(
        [Parameter(Mandatory=$true)] [string] $serverName,
        [Parameter(Mandatory=$true)] [string] $databaseName
    )
    begin{
        Write-Host "Scanning for index usage in database '$databaseName'..." -BackgroundColor Blue -ForegroundColor White
    }
    process {
        $serverName = $serverName.Replace("'", "")
        $serverName = $serverName.Trim()

        $databaseName = $databaseName.Replace("'", "")
        $databaseName = $databaseName.Trim()

        $connection = new-object System.Data.SqlClient.SQLConnection("Data Source=$serverName;Integrated Security=SSPI;Initial Catalog=$databaseName");
        $baseQuery = "SELECT
            object_name(object_id(usage.object_id)) AS TableName,
            indexes.name AS IndexName,
            usage.user_seeks AS UserSeeks,
            usage.user_seeks + usage.user_scans + usage.user_lookups + usage.user_updates AS TotalUserAccesses,
            usage.user_updates AS UserWrites
        FROM
            sys.dm_db_index_usage_stats AS usage
            INNER JOIN sys.indexes
                ON usage.index_id = indexes.index_id
                AND usage.object_id = indexes.object_id
            INNER JOIN sys.databases
                ON usage.database_id = databases.database_id
        WHERE
            databases.name = '$databaseName'
        ORDER BY
            usage.last_user_seek DESC;"

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
            $color = "Green"
        } else {
            Write-Host "No index usage data found for database '$databaseName'. Please ensure the database name is correct." -BackgroundColor Yellow -ForegroundColor Black
            $color = "Red"
        }
        

    }   
    End {
        Write-Host "Finished checking for index usage in database '$databaseName'." -BackgroundColor $color -ForegroundColor White
    }
    
}

SQLServerIndexUsage

