import sqlite3

def write_to_db(db_file_path, bin_id, bin_weight):
    with sqlite3.connect(db_file_path) as conn:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO weights (id, weight) VALUES (?, ?)",
                       (bin_id, bin_weight))
        conn.commit()
