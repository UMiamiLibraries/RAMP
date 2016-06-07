<?php include('conf/db.php') ?>
<div class="inner-area">
    <div class="pure-g">
        <div class="pure-u-1">
            <div class="content_box">

                <form class="pure-form-stacked" method="post">
                    <fieldset>
                        <legend>Install RAMP</legend>
                        <label>
                            Enter your database hostname
                            <input name="db_host" type="text" value="<?php echo $db_host; ?>" required>
                        </label>
                        <label>
                            Enter your database username
                            <input name="db_user" type="text" value="<?php echo $db_user; ?>" required>
                        </label>

                        <label>
                            Enter your database password
                            <input name="db_pass" type="text" value="<?php echo $db_pass; ?>" required>
                        </label>
                        <label>
                            Enter your database name
                            <input name="db_default" type="text" value="<?php echo $db_default; ?>"  required>
                        </label>
                        <label>
                            Database port
                            <input name="db_port" type="text" value="<?php echo $db_port; ?>" required>
                        </label>
                        <input class="pure-button ramp-button" type="submit" value="Install RAMP">
                    </fieldset>
                </form>
            </div>
        </div>
    </div>
</div>
