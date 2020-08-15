var mysql = require("mysql");
var config = require("../config/default.json");

// var createConnection = () => mysql.createConnection(config["mysql"]);
const pool = mysql.createPool({
    ...config.mysql
}); 

// cột is_delete trong các bảng, để xác định đã xoá hay không xoá
// 1: true - đã xoá, 0: false - chưa xoá
var __is_delete__ = "is_delete";
let i = 0;
module.exports = {
  load: sql => {
    return new Promise((resolve, reject) => {
      /* var connection = createConnection();
      connection.connect(); */
      //console.log("load sql: " + sql);
      pool.query(sql, (error, results, fields) => {
        console.log('db start');
        i++;
        if (error) {
          reject(error);
        } else {
          resolve(results);
        }
        console.log(` db-end ${i} times`);
  //        connection.end();
      });
    });
  },

  loadAll: (Table) => {
    return new Promise((resolve, reject) => {
      /*
      var sql = `select * from ${Table}`;
      console.log(sql);
      pool.query(sql, (error, results, fields) => {
        if (error) {
          reject(error);
        } else {
          resolve(results);
        }
  //        connection.end();
      });
    });
  },

  loadAllExist: (Table, is_delete) => {
    return new Promise((resolve, reject) => {
      /* var connection = createConnection();
      connection.connect(); */
      var is_deleteField = "is_delete";
      var sql = `select * from ${Table} where ${is_deleteField} = '${is_delete}'`;
      console.log("loadByExist sql: " + sql);
      pool.query(sql, (error, results, fields) => {
        if (error) {
          reject(error);
        } else {
          resolve(results);
        }
  //        connection.end();
      });
    });
  },

  loadBy: (Table, Field, Key) => {
    return new Promise((resolve, reject) => {
      /* var connection = createConnection();
      connection.connect(); */
      var sql = `select * from ${Table} where ${Field} = '${Key}'`;
      console.log(sql);
      pool.query(sql, (error, results, fields) => {
        if (error) {
          reject(error);
        } else {
          resolve(results);
        }
  //        connection.end();
      });
    });
  },

  loadByExist: (Table, Field, Key, is_delete) => {
    return new Promise((resolve, reject) => {
      /* var connection = createConnection();
      connection.connect(); */
      var is_deleteField = "is_delete";
      var sql = `select * from ${Table} where ${Field} = '${Key}' and ${is_deleteField} = '${is_delete}'`;
      console.log("loadByExist sql: " + sql);
      pool.query(sql, (error, results, fields) => {
        if (error) {
          reject(error);
        } else {
          resolve(results);
        }
  //        connection.end();
      });
    });
  },

  add: (tableName, entity) => {
    return new Promise((resolve, reject) => {
  
      var sql = `insert into ${tableName} set ?`;
      pool.query(sql, entity, (error, results) => {
        if (error) {
          reject(error);
        } else {
          resolve(results.insertId);
        }
  //        connection.end();
      });
    });
  },

  update: (tableName, idField, entity, id) => {
    return new Promise((resolve, reject) => {
      var sql = `update ${tableName} set ? where ${idField} = ?`;
      pool.query(sql, [entity, id], (error, results, fields) => {
        if (error) {
          reject(error);
        } else {
          resolve(results.changedRows);
        }
  //        connection.end();
      });
    });
  },

  delete: (tableName, idField, id) => {
    return new Promise((resolve, reject) => {
      var sql = `delete from ${tableName} where ${idField} = ?`;
      pool.query(sql, id, (error, results, fields) => {
        if (error) {
          reject(error);
        } else {
          resolve(results.affectedRows);
        }
  //        connection.end();
      });
    });
  },

  //update isDelete = 1
  is_delete: (tableName, idField, id, status) => {
    return new Promise((resolve, reject) => {
      var is_deleteField = "is_delete";
      var sql = `update ${tableName} set ${is_deleteField} = ${status} where ${idField} = ?`;
      pool.query(sql, id, (error, results, fields) => {
        if (error) {
          reject(error);
        } else {
          resolve(results.changedRows);
        }
  //        connection.end();
      });
    });
  }

  // load tuần tự, không như promise
  // load_sequentially: (sql, fn) => {
  //   var connection = createConnection();
  //   connection.connect();
  //   pool.query(sql, (error, results, fields) => {
  //     if (error) {
  //       console.log(error.sqlMessage);
  //     } else {
  //       // console.log(results);
  //       fn(results);
  //     }
  //     connection.end();
  //   });
  // },

  // add: (tableName, entity, fn) => {
  //   var connection = createConnection();
  //   var sql = `insert into ${tableName} set ?`;
  //   connection.connect();
  //   pool.query(sql, entity, (error, results, fields) => {
  //     if (error) {
  //       console.log(error.sqlMessage);
  //     } else {
  //       fn(results.insertId);
  //     }
  //     connection.end();
  //   });
  // },

  // update: (tableName, idField, entity, id, fn) => {
  //   var connection = createConnection();
  //   var sql = `update ${tableName} set ? where ${idField} = ?`;
  //   connection.connect();
  //   pool.query(sql, [entity, id], (error, results, fields) => {
  //     if (error) {
  //       console.log(error.sqlMessage);
  //     } else {
  //       fn(results.changedRows);
  //     }
  //     connection.end();
  //   });
  // }
};
