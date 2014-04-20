package DesktopFullApp;
use Carp;
use Mojo::Base 'Mojolicious';
use DBI;

# This method will run once at server start
sub startup {
  my $self = shift;

    # connect to database
    use DBI;
    my $dbh = DBI->connect( "dbi:SQLite:database.db", "", "" )
      or croak "Could not connect: $!";

    # shortcut for use in template
   $self->helper( db => sub { $dbh });

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  my $config = $self->plugin('Config');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
  $r->get('/kill') -> to('example#kill');


    # setup route which receives data and returns to /
  $r->post('/insert') -> to('example#insert');

  my $insert;

  while (1) {    # Repeat forever until disk space is available.

        # create insert statement
        $insert = eval { $dbh->prepare('INSERT INTO people VALUES (?,?)') };

        # break out of loop if statement prepared
        last if $insert;

       # if statement didn't prepare, assume its because the table doesn't exist
        warn "Creating table 'people'\n";
        $dbh->do('CREATE TABLE people (name varchar(255), age int);');
    }

    $self->app->secrets(["Don't tell anyone"]);
}

1;
