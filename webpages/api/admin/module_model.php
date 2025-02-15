<?php

require_once(__DIR__ . '/../../db_exceptions.php');

class PlanzModule {
    public $id;
    public $name;
    public $packageName;
    public $description;
    public $isEnabled;

    function __construct($id, $name, $packageName, $description, $isEnabled) {
        $this->id = $id;
        $this->name = $name;
        $this->packageName = $packageName;
        $this->description = $description;
        $this->isEnabled = $isEnabled;
    }

    // Some modules have a "descriptor" to help describe the full feature set
    // of a module. The Descriptor is implemented in a file that needs to
    // be "require"-d by any page that uses those functions. This method
    // provides the name of the file, with the assumption that the file name
    // follows a pattern that can be derived from the package name.
    public function getDescriptorFileName() {
        return "/module/" . str_replace('.', '/', $this->packageName) . "_module.php";
    }

    // Some modules have a "descriptor" to help describe the full feature set
    // of a module. The Descriptor is implemented in a class with a special
    // naming pattern.
    public function getDescriptorClassName() {
        $index = strpos($this->packageName, ".");
        if ($index > 0) {
            $namespaceName = substr($this->packageName, 0, $index);
            if ($namespaceName == "planz") {
                $namespaceName = 'PlanZ\Module\\';
            } else {
                $namespaceName = ucfirst(mb_strtolower($namespaceName)) . '\\';
            }

            $temp = substr($this->packageName, $index + 1);
            $className = "";
            while (strpos($temp, '_') !== false) {
                $index = strpos($temp, '_');
                $className .= ucfirst(mb_strtolower(substr($temp, 0, $index)));
                $temp = substr($temp, $index + 1);
            }
            $className .= ucfirst(mb_strtolower($temp));

            return $namespaceName . $className . "Module";
        } else {
            return null;
        }
    }

    public function getDescriptorClass() {
        try {
            return new ReflectionClass($this->getDescriptorClassName());
        } catch (Exception|Error $e) {
            // skip it
        }
    }

    public static function findAll($db) {
        $query = <<<EOD
        SELECT id, name, package_name, description, is_enabled
             FROM module M
           ORDER BY M.name, M.id;
EOD;
        $stmt = mysqli_prepare($db, $query);
        return PlanzModule::processSqlStatement($stmt,$query);
    }

    public static function findAllEnabledModules($db) {
        $query = <<<EOD
        SELECT id, name, package_name, description, is_enabled
          FROM module M
         WHERE is_enabled = 1;
EOD;
        $stmt = mysqli_prepare($db, $query);
        return PlanzModule::processSqlStatement($stmt,$query);
    }

    public function updateEnabled($db, $value) {
        $query = <<<EOD
           UPDATE module M
              SET is_enabled = ?
            WHERE id = ?;
EOD;
        $stmt = mysqli_prepare($db, $query);
        mysqli_stmt_bind_param($stmt, "ii", $value, $this->id);
        if ($stmt->execute()) {
            mysqli_stmt_close($stmt);
        } else {
            throw new DatabaseSqlException("There was a problem with the update: $query");
        }
    }

    public static function findByPackageName($db, $packageName) {
        $query = <<<EOD
        SELECT id, name, package_name, description, is_enabled
             FROM module M
            WHERE package_name = ?
           ORDER BY M.name, M.id;
EOD;
        $stmt = mysqli_prepare($db, $query);
        mysqli_stmt_bind_param($stmt, "s", $packageName);
        $result = PlanzModule::processSqlStatement($stmt,$query);
        if (count($result) == 1) {
            return $result[0];
        } else {
            return null;
        }
    }

    private static function processSqlStatement($stmt, $query) {
        if (mysqli_stmt_execute($stmt)) {
            $result = [];
            $resultSet = mysqli_stmt_get_result($stmt);
            while ($row = mysqli_fetch_object($resultSet)) {
                $record = new PlanzModule($row->id, $row->name, $row->package_name, $row->description, $row->is_enabled);
                $result[] = $record;
            }
            mysqli_stmt_close($stmt);
            return $result;
        } else {
            throw new DatabaseSqlException("Query could not be executed: $query");
        }
    }

    function asJson() {
        return array("id" => $this->id,
            "name" => $this->name,
            "packageName" => $this->packageName,
            "description" => $this->description,
            "isEnabled" => $this->isEnabled ? true : false
        );
    }

    static function asJsonArray($modules) {
        $result = array();
        foreach ($modules as $m) {
            $result[] = $m->asJson();
        }
        return $result;
    }
}

?>