"""empty message

Revision ID: 67e5cf5585b5
Revises: 
Create Date: 2020-09-19 02:35:12.229009

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '67e5cf5585b5'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('attendee',
    sa.Column('username', sa.String(length=20), nullable=False),
    sa.Column('password', sa.String(length=20), nullable=False),
    sa.Column('address', sa.Text(), nullable=False),
    sa.Column('phone', sa.String(length=10), nullable=False),
    sa.Column('email_id', sa.String(length=50), nullable=False),
    sa.Column('image', sa.Text(), nullable=False),
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('name', sa.String(length=100), nullable=False),
    sa.Column('age', sa.Integer(), nullable=False),
    sa.Column('gender', sa.String(length=10), nullable=False),
    sa.Column('verification_image', sa.Text(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('organisation',
    sa.Column('username', sa.String(length=20), nullable=False),
    sa.Column('password', sa.String(length=20), nullable=False),
    sa.Column('address', sa.Text(), nullable=False),
    sa.Column('phone', sa.String(length=10), nullable=False),
    sa.Column('email_id', sa.String(length=50), nullable=False),
    sa.Column('image', sa.Text(), nullable=False),
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('name', sa.String(length=100), nullable=False),
    sa.Column('subscription', sa.Boolean(), nullable=False),
    sa.Column('org_details', sa.Text(), nullable=False),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('event',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('title', sa.String(length=100), nullable=False),
    sa.Column('description', sa.Text(), nullable=False),
    sa.Column('start_date', sa.DateTime(), nullable=False),
    sa.Column('end_date', sa.DateTime(), nullable=False),
    sa.Column('location', sa.Text(), nullable=False),
    sa.Column('category', sa.String(length=100), nullable=False),
    sa.Column('speciality', sa.Text(), nullable=False),
    sa.Column('entry_amount', sa.Integer(), nullable=False),
    sa.Column('image', sa.Text(), nullable=False),
    sa.Column('organiser_id', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['organiser_id'], ['organisation.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('favourites',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('attendee_id', sa.Integer(), nullable=False),
    sa.Column('event_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['attendee_id'], ['attendee.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('registration',
    sa.Column('attendee_id', sa.Integer(), nullable=False),
    sa.Column('event_id', sa.Integer(), nullable=False),
    sa.Column('unique_key', sa.Text(), nullable=False),
    sa.Column('status', sa.String(length=6), nullable=False),
    sa.ForeignKeyConstraint(['attendee_id'], ['attendee.id'], ),
    sa.ForeignKeyConstraint(['event_id'], ['event.id'], )
    )
    op.create_table('reviews',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('attendee_id', sa.Integer(), nullable=False),
    sa.Column('event_id', sa.Integer(), nullable=False),
    sa.Column('review', sa.Text(), nullable=False),
    sa.Column('rating', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['attendee_id'], ['attendee.id'], ),
    sa.ForeignKeyConstraint(['event_id'], ['event.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('reviews')
    op.drop_table('registration')
    op.drop_table('favourites')
    op.drop_table('event')
    op.drop_table('organisation')
    op.drop_table('attendee')
    # ### end Alembic commands ###
